//
//  CommentTableViewCell.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 05/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
