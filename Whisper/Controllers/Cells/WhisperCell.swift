//
//  WhisperCell.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

import UIKit
import SDWebImage

class WhisperCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var whisperImageView: UIImageView!
    @IBOutlet weak var heartsLabel: UILabel!
    
    static let identifier = "WhisperCell"
    
    func setup(with whisper: Whisper) {
        if let imageUrl = URL(string: whisper.url) {
            whisperImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
        }
        heartsLabel.text = "❤️ \(whisper.me2)"
    }

}
