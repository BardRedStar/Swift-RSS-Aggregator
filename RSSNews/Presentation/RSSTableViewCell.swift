//
//  RSSTableViewCell.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        titleLabel = nil
        contentLabel = nil
    }
}
