//
//  temp.swift
//  collectionVCwith player
//
//  Created by Pratik Gavit on 21/03/23.
//

import UIKit
import AVFoundation
import AVKit
class MyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playButton: UIButton?
    var fullscreenButton: UIButton?
    var currentIndexPath: IndexPath?
    var videoURLs: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCollectionViewCell")
        
        // Set up video player
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        collectionView.layer.addSublayer(playerLayer!)
        
        // Set up play button
        playButton = UIButton(type: .system)
        playButton?.setImage(UIImage(named: "play"), for: .normal)
        playButton?.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        collectionView.addSubview(playButton!)
        
        // Set up fullscreen button
        fullscreenButton = UIButton(type: .system)
        fullscreenButton?.setImage(UIImage(named: "fullscreen"), for: .normal)
        fullscreenButton?.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)
        collectionView.addSubview(fullscreenButton!)
        
        // Hide buttons initially
        playButton?.isHidden = true
        fullscreenButton?.isHidden = true
        
        // Add tap gesture recognizer to video player view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerViewTapped))
//        playerLayer?.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UICollectionViewDelegate and UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.videoURL = videoURLs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Start playing video
        currentIndexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        player = AVPlayer(url: (cell.videoURL ?? URL(string: ""))!)
        playerLayer?.player = player
        player?.play()
        
        // Show play and fullscreen buttons
        playButton?.isHidden = false
        fullscreenButton?.isHidden = false
        resetHideButtonsTimer()
    }
    
    // MARK: - UIScrollViewDelegate methods
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        player?.pause()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            player?.play()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        player?.play()
    }
    
    // MARK: - Button and gesture recognizer handlers
    
    @objc func playButtonTapped() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
                playButton?.setImage(UIImage(named: "play"), for: .normal)
            } else {
                player.play()
                playButton?.setImage(UIImage(named: "pause"), for: .normal)
            }
            resetHideButtonsTimer()
        }
    }
    
    @objc func fullscreenButtonTapped() {
        // Go fullscreen
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }
    
    @objc func playerViewTapped() {
        // Toggle play button visibility
        playButton?.isHidden.toggle()
        fullscreenButton?.isHidden.toggle()
        
        // Reset hide buttons timer
        resetHideButtonsTimer()
    }
    
    // MARK: - Helper methods
    
    func resetHideButtonsTimer() {
        // Hide buttons after 3 seconds
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(hideButtons), with: nil, afterDelay: 3.0)
    }
    
    @objc func hideButtons() {
        playButton?.isHidden = true
        fullscreenButton?.isHidden = true
    }
}

