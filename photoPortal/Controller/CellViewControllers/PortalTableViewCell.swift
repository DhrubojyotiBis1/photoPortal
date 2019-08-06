//
//  PortalTableViewCell.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 03/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class PortalTableViewCell: UITableViewCell {

    @IBOutlet weak var portalDiscription: UILabel!
    @IBOutlet weak var portalCatogory: UILabel!
    @IBOutlet weak var portalProductName: UILabel!
    @IBOutlet weak var portalImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
