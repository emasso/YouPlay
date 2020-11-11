//
//  VideoListViewModel.swift
//  YouPlayer
//
//  Created by Elisabet Massó on 10/11/2020.
//

import Foundation

class VideoListViewModel {
    
    // MARK: - Parameters
    
    fileprivate(set) var videoList: [VideoModel]?
    
    // MARK: - Init Method
    
    /// The list is setted with `VideoModel` objects.
    init() {
        videoList = []
        videoList?.append(VideoModel(source: "commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg", title: "Big Buck Bunny"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg", title: "Elephant Dream"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg", title: "For Bigger Blazes"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg", title: "For Bigger Escape"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg", title: "For Bigger Fun"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg", title: "For Bigger Joyrides"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerMeltdowns.jpg", title: "For Bigger Meltdowns"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg", title: "Sintel"))
        videoList?.append(VideoModel(source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", thumb: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/TearsOfSteel.jpg", title: "Tears of Steel"))
    }
}
