//
//  VideoListViewController.swift
//  YouPlayer
//
//  Created by Elisabet Massó on 09/11/2020.
//

import UIKit
import PlayerTracker

class VideoListViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let viewModel = VideoListViewModel()
    
    // MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Video Menu"

        tableView.delegate = self
        tableView.dataSource = self
        
        registerTableViewCells()
    }
    
    /// Registers the cells.
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "VideoListTableViewCell", bundle: nil)
        tableView.register(textFieldCell, forCellReuseIdentifier: "VideoListTableViewCell")
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "The provided video URL is not valid for the player. Please try another video.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let urlList = viewModel.videoList else { return 0 }
        return urlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath) as? VideoListTableViewCell, let video = viewModel.videoList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(title: video.title, thumb: video.thumb)

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let video = viewModel.videoList?[indexPath.row] else { return }
        guard let vc = UIStoryboard(name: "VideoPlayerView", bundle: Bundle(for: type(of: self))).instantiateViewController(identifier: "VideoPlayerViewId") as? VideoPlayerViewController else { return }
        vc.videoModel = video
        if PlayerTracker.shared.registerAndVerifyResource(by: video.source) {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            showErrorAlert()
        }
    }
    
}
