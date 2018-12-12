//
//  StationTableViewCell.swift
//  WrocNav
//
//  Created by Kacper Raczy on 12.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.backgroundColor = highlighted ? UIColor.wnLightGray : UIColor.white
    }
    
}
