//
//  ExpandableCell.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 4.09.21.
//

import UIKit

class ExpandableCell: UITableViewCell {
    @IBOutlet weak var informationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
