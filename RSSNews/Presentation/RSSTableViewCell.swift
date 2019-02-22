//
//  RSSTableViewCell.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String! {
        didSet{
            titleLabel.text = title
        }
    }
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    var content: String! {
        didSet{
            contentLabel.text = content
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
