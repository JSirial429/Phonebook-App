//
//  TableCell.swift
//  SearchBarInTable
//
//  Created by Luismel Rosquete on 07/20/17.
//  Copyright © 2019 Luismel Rosquete. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
