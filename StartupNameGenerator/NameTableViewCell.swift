//
//  NameTableViewCell.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/11/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var startupNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
