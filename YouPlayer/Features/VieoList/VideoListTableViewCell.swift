//
//  VideoListTableViewCell.swift
//  YouPlayer
//
//  Created by Elisabet Massó on 09/11/2020.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var thumbImg: UIImageView!
    @IBOutlet private weak var titleLbl: UILabel!
    
    // MARK: - Class Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.textAlignment = .center
        thumbImg.contentMode = .scaleAspectFill
    }
    
    func configure(title: String, thumb: String) {
        titleLbl.text = title
        /// We convert the URL to an image.
        guard let thumbURL = URL(string: thumb) else { return }
        if let thumbData = try? Data(contentsOf: thumbURL) {
            thumbImg.image = UIImage(data: thumbData)
        }

    }
    
}
