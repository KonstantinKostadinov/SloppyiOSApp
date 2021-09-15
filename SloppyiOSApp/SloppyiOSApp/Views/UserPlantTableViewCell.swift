//
//  UserPlantTableViewCell.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 2.09.21.
//

import UIKit

class UserPlantTableViewCell: UITableViewCell {
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
