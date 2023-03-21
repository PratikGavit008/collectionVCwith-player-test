//
//  CustomCell.swift
//  collectionVCwith player
//
//  Created by Pratik Gavit on 21/03/23.
//

import UIKit
import AVFoundation
import AVKit

class MyCollectionViewCell: UICollectionViewCell {

    var videoURL: URL?
    var thumbnailImage: UIImage? {
        didSet {
            thumbnailImageView.image = thumbnailImage
        }
    }

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var playerLayer: AVPlayerLayer?

    override func prepareForReuse() {
        super.prepareForReuse()

        // Stop playing video
        playerLayer?.player?.pause()
        playerLayer?.player = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(playButton)

        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            playButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func playButtonTapped() {
        if let videoURL = videoURL {
            let player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = thumbnailImageView.frame
            playerLayer?.videoGravity = .resizeAspectFill
            contentView.layer.addSublayer(playerLayer!)

            player.play()
            playButton.isHidden = true
        }
    }

}

