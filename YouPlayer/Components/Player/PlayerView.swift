//
//  PlayerView.swift
//  YouPlayer
//
//  Created by Elisabet Massó on 07/11/2020.
//

import UIKit
import AVFoundation
import PlayerTracker

/// The view that plays the resource given.
class PlayerView: UIBaseView {
    
    // MARK: - Properties
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var isPlaying = false
    private var isEnded = false

    /// Button for the play/pause/resume
    private let controlBtn: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleControls), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    /// Label to show the time left of the video
    private let leftTimeLbl: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    /// Label to show the current time of the video
    private let currentTimeLbl: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    /// Slider that shows the video position
    private let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        slider.thumbTintColor = UIColor.red
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderValueChanged), for: .valueChanged)
        slider.isHidden = true
        return slider
    }()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var playerView: UIView!
    
    // MARK: - Class Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerView.backgroundColor = UIColor.black
    }
    
    /**
     Configures the view to play the resource.
     
     - Parameter videoURL: The URL of the resource.
     */
    func configure(videoURL: URL) {
        configurePlayer(withURL: videoURL)
        configureControls()
    }
    
    /// Restart the class variables.
    func stopPlayer() {
        player = nil
        playerLayer = nil
        isPlaying = false
        isEnded = false
        
    }
    
    /// Removes the observers.
    deinit {
        player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Allows to turn the phone to see the player in full screen.
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = bounds
    }
    
    /// Initiates and configures the player.
    private func configurePlayer(withURL url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer!)
        playerView.clipsToBounds = true
        handleControls()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: [.new], context: nil)
        
        /// To track the player progress
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
            self.currentTimeLbl.text = self.getTextTimeFrom(time: progressTime)
            if let duration =  self.player?.currentItem?.duration {
                self.leftTimeLbl.text = "-\(self.getTextTimeFrom(time: duration-progressTime))"
                let totalSeconds = CMTimeGetSeconds(progressTime)
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(totalSeconds / durationSeconds)
            }
        })
    }
    
    /// Sets the constraints for `controlBtn`, `leftTimeLbl`, `currentTimeLbl` and `videoSlider`.
    private func configureControls() {
        controlBtn.frame = bounds
        addSubview(controlBtn)
        controlBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        controlBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        controlBtn.widthAnchor.constraint(equalToConstant: 15).isActive = true
        controlBtn.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        leftTimeLbl.frame = bounds
        addSubview(leftTimeLbl)
        leftTimeLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        leftTimeLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftTimeLbl.widthAnchor.constraint(equalToConstant: 60).isActive = true
        leftTimeLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        currentTimeLbl.frame = bounds
        addSubview(currentTimeLbl)
        currentTimeLbl.leftAnchor.constraint(equalTo: controlBtn.rightAnchor, constant: 10).isActive = true
        currentTimeLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimeLbl.widthAnchor.constraint(equalToConstant: 60).isActive = true
        currentTimeLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        videoSlider.frame = bounds
        addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: leftTimeLbl.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLbl.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    /// Changes the player event and the player controls' image.
    @objc private func handleControls() {
        if isPlaying {
            player?.pause()
            controlBtn.setImage(UIImage(named: "play"), for: .normal)
            PlayerTracker.shared.trackPlayerEvent(event: .pause)
        } else if !isPlaying && isEnded {
            isEnded = false
            player?.seek(to: CMTime.zero)
            player?.play()
            controlBtn.setImage(UIImage(named: "pause"), for: .normal)
            PlayerTracker.shared.trackPlayerEvent(event: .resume)
        } else {
            player?.play()
            controlBtn.setImage(UIImage(named: "pause"), for: .normal)
            PlayerTracker.shared.trackPlayerEvent(event: .play)
        }
        isPlaying = !isPlaying
    }
    
    /// Restarts the video.
    @objc private func replayVideo() {
        if isPlaying && !isEnded {
            controlBtn.setImage(UIImage(named: "resume"), for: .normal)
            PlayerTracker.shared.trackPlayerEvent(event: .stop)
        }
        isPlaying = false
        isEnded = true
    }
    
    /// Manages the slider to change the current time of the video.
    @objc private func handleSliderValueChanged() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = videoSlider.value * Float(totalSeconds)
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completed) in
                //
            })
        }
    }
    
    /// Observes when the resource is ready to start and shows the controls.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            controlBtn.isHidden = false
            currentTimeLbl.isHidden = false
            leftTimeLbl.isHidden = false
            videoSlider.isHidden = false
            NotificationCenter.default.addObserver(self, selector: #selector(replayVideo), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    /// Converts the time to a `String`.
    private func getTextTimeFrom(time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        let secondsText = String(format: "%02d", seconds)
        let minutesText = String(format: "%02d", Int(totalSeconds / 60))
        return "\(minutesText):\(secondsText)"
    }
    
}
