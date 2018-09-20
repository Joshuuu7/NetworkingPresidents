//
//  PresidentCell.swift
//  NetworkingPresidents
//
//  Created by Joshua Aaron Flores Stavedahl on 11/19/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//

import UIKit

class PresidentCell: UITableViewCell {
    
    @IBOutlet weak var presidentImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var politicalPartyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
