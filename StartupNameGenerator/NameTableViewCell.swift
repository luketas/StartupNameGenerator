//
//  NameTableViewCell.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/11/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import UIKit

protocol NameCellDelegate {
    func favoriteBtnTapped(cell: NameTableViewCell)
}

class NameTableViewCell: UITableViewCell {
   
   var delegate: NameCellDelegate?
    
    @IBOutlet weak var startupNameLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBAction func favoriteBtnPressed(_ sender: Any) {
        if let _ = delegate {
            delegate?.favoriteBtnTapped(cell: self)
        }
      
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
