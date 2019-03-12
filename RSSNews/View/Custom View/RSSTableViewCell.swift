//
//  RSSTableViewCell.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit
import Reusable

final class RSSTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var titleLabel: UILabel!

    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    @IBOutlet private weak var contentLabel: UILabel!

    var content: String! {
        didSet {
            contentLabel.text = content
        }
    }

    @IBOutlet private weak var newsImageView: UIImageView!

    var imageContent: UIImage! {
        didSet {
            newsImageView.image = imageContent
        }
    }

    @IBOutlet private weak var dateLabel: UILabel!

    var date: String! {
        didSet {
            dateLabel.text = date
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        newsImageView.layer.cornerRadius = newsImageView.frame.size.height / 2
        newsImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addImageGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        newsImageView.addGestureRecognizer(gestureRecognizer)
    }
}
