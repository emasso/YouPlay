//
//  VideoPlayerViewController.swift
//  YouPlayer
//
//  Created by Elisabet Massó on 07/11/2020.
//

import UIKit

class VideoPlayerViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var playerView: PlayerView!
    
    // MARK: - Parameters
    
    var videoModel: VideoModel?
    
    // MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\(videoModel?.title ?? "")"
        
        guard let source = videoModel?.source, let videoURL = URL(string: source) else { return }
        playerView.configure(videoURL: videoURL)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.stopPlayer()
    }

}
