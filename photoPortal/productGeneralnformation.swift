//
//  productInformation.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 04/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class productGeneralnformation{
    var productName = String()
    var catagory = String()
    var discription = String()
    var filePath = String()
    var commentID = String()
    var image = UIImage()
    
    init(productName:String,catagory:String,discription:String,filePath:String,commentID:String) {
        self.productName = productName
        self.catagory = catagory
        self.discription = discription
        self.commentID = commentID
        self.filePath = filePath
    }
}
