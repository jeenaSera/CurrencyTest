//
//  cell.swift
//  SkillTest
//
//  Created by jeena azeez on 08/03/2021.
//

import UIKit

class cell: UITableViewCell {
    @IBOutlet weak var label1:UILabel!
    
    @IBOutlet weak var label2:UILabel!
    
    @IBOutlet weak var image1:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
