//
//  PlayerTracker.swift
//  PlayerTracker
//
//  Created by Elisabet Massó on 07/11/2020.
//

import UIKit

/// Types of events for tracking
public enum PlayerEvent {
    
    case play
    case pause
    case resume
    case stop
}

/// The object with the player events
struct PlayerEventCounter {
    
    /// The URL to be tracked
    var resourceURL: String?
    
    /// The plays counter
    var play = 0
    
    /// The pauses counter
    var pause = 0
    
    /// The resumes counter
    var resume = 0
    
    /// The array of elapsed times between pause and play
    var elapsedTime: [Int: String] = [:]
    
}

/// An event tracker for video players
public class PlayerTracker {
    
    /// The `shared` property
    public static let shared = PlayerTracker()
    
    /// The time between pause/play
    private var timer: Timer?
    
    /// The time counter between pause/play
    private var counter = 0
    
    /// The event tracker per video
    private var eventCounter: PlayerEventCounter?
    
    /**
     Registers the resource and verifies if the URL is valid.
     
     - Parameter urlString: The URL to verify and register.
     
     - Returns: A a bool that lets the app know is the source is valid.
     */
    public func registerAndVerifyResource(by urlString: String) -> Bool {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            registerResource(by: urlString)
            print("VALID URL: \(urlString)")
            return true
        }
        print("INVALID URL: \(urlString)")
        return false
    }
    
    /**
     Registers the resource URL.
     
     Calling this method initiates the tracking of the resource
     and makes an HTTP request to a public API
     or finishes the previous resource tracking by printing the data.
     
     - Parameter url: The URL to verify and register.
     */
    public func registerResource(by url: String) {
        print("URL \(url)")
        if eventCounter?.resourceURL != url {
            eventCounter = PlayerEventCounter()
            let g = GorestService()
            g.getUser(by: "5") { (gorestModel) in
                if let gorestModelList = gorestModel?.data {
                    for gorest in gorestModelList {
                        print("HTTP rquest response SUCCESS:")
                        print("\tid: \(gorest.id)")
                        print("\tname: \(gorest.name ?? "")")
                        print("\temail: \(gorest.email ?? "")")
                        print("\tgender: \(gorest.gender ?? "")")
                    }
                }
            } failure: { (error) in
                print("HTTP rquest response ERROR: \(error)")
            }
        }
        eventCounter?.resourceURL = url
    }
    
    /**
     Tracks the player event.
     
     Calling this method increments the `play`, `pause` or `resume`
     or in case of `stop` prints all the events.
     
     - Parameter event: The type of the event.
     */
    public func trackPlayerEvent(event: PlayerEvent) {
        switch event {
        case .play:
            eventCounter?.play += 1
            getElapsedTimeBetweenPauseAndPlay()
        case .pause:
            eventCounter?.pause += 1
            getElapsedTimeBetweenPauseAndPlay()
        case .resume:
            eventCounter?.resume += 1
        case .stop:
            if let eventCounter = eventCounter {
                let elapsedTimeList = eventCounter.elapsedTime.sorted(by: { $0.0 < $1.0 } )
                print("Events:")
                print("\tURL: \(eventCounter.resourceURL ?? "")")
                print("\tPlay button was pressed: \(eventCounter.play) times")
                print("\tPause button was pressed: \(eventCounter.pause) times")
                print("\tResume button was pressed: \(eventCounter.resume) times")
                print("\tElapsed times:")
                for elapsedTime in elapsedTimeList {
                    print("\t\t\(elapsedTime.key): \(elapsedTime.value)")
                }
             }
        }
    }
    
    /// Initiates the timer if not created or invalidates it if created before.
    private func getElapsedTimeBetweenPauseAndPlay() {
        if let timer = timer {
            if let pauseIndex = eventCounter?.pause {
                eventCounter?.elapsedTime[pauseIndex] = "\(counter) seconds"
            }
            timer.invalidate()
            self.timer = nil
            counter = 0
        } else if eventCounter?.pause ?? 0 > 0 {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
        }
    }
    
    /// Updates the `counter` for ther timer.
    @objc private func updateTimer(_ timer: Timer) {
        counter += 1
    }
    
}
