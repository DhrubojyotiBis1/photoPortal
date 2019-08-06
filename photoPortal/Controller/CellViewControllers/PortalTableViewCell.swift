//
//  PortalTableViewCell.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 03/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PortalTableViewCell: UITableViewCell {

    @IBOutlet weak var portalDiscription: UILabel!
    @IBOutlet weak var portalCatogory: UILabel!
    @IBOutlet weak var portalProductName: UILabel!
    @IBOutlet weak var portalImageView: UIImageView!
    
    var productGeneralnformation : productGeneralnformation?{
        didSet{
            portalDiscription.text! = "Discription :- "+(productGeneralnformation?.discription)!
            portalCatogory.text! = "Catagory :- "+(productGeneralnformation?.catagory)!
            portalProductName.text! = "Product Name :- "+(productGeneralnformation?.productName)!
            self.downloadImages(withUrl: (productGeneralnformation?.filePath)!)
        }
    }
    
    private func downloadImages(withUrl url:String){
        let httpsReference = Storage.storage().reference(forURL: url)
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error : ",error.localizedDescription)
                SVProgressHUD.showError(withStatus: messages().somethingWentWrong)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.portalImageView.image = image
                self.productGeneralnformation?.image = image!
            }
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
