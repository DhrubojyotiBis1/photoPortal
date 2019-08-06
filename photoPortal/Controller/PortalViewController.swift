//
//  PortalViewController.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 03/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PortalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var commentImage = UIImage()
    var commentID = Int()
    //var isDataBengProcessed = true
    var products = [productGeneralnformation]()
    var productImages = [UIImage]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configure()
    }
    /*override func viewWillAppear(_ animated: Bool) {
        
        if (self.isDataBengProcessed){
            SVProgressHUD.show()
        }else{
            SVProgressHUD.dismiss()
        }
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portalTableViewCell", for: indexPath) as! PortalTableViewCell
        cell.portalCatogory.text! = "Product Catagary :- " + products[indexPath.row].catagory
        cell.portalProductName.text! = "Product Name :- " + products[indexPath.row].productName
        cell.portalDiscription.text! = "Product Description :- " + products[indexPath.row].discription
        cell.portalImageView.image! = productImages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.commentImage = self.productImages[indexPath.row]
        self.commentID = Int(self.products[indexPath.row].commentID)!
        performSegue(withIdentifier: "goToCommentVC", sender: nil)
    }
    
    private func configure(){
        SVProgressHUD.show()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker.delegate = self
        self.getData()
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func addProductButtonPressed(_ sender: UIBarButtonItem) {
        self.pickImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddProductVC"{
            let distination = segue.destination as! AddProductViewController
            distination.pickedImage = self.selectedImage
            distination.commentID = self.productImages.count + 1
        }else if segue.identifier == "goToCommentVC"{
            let destination = segue.destination as! CommentViewController
            destination.selectedImage = self.commentImage
            destination.commentID = self.commentID
        }
    }
    
}


extension PortalViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    private func pickImage(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.selectedImage = tempImage
        self.performSegue(withIdentifier: "goToAddProductVC", sender: nil)
    }
}


extension PortalViewController{
    //Data downloading part:
    
    private func getData(){
        let dateBaseRef = Database.database().reference().child("photoPortalProductInformation")
        dateBaseRef.observe(.value) { (DataSnapshot) in
            if DataSnapshot.hasChildren() != true{
                SVProgressHUD.dismiss()
            }
        }
        dateBaseRef.observe(.childAdded) { (DataSnapshot) in
            let productGeneralInfo = productGeneralnformation()
            let productInformation = DataSnapshot.value as! [String:String]
            productGeneralInfo.productName = productInformation["name"]!
            productGeneralInfo.catagory = productInformation["catagory"]!
            productGeneralInfo.discription = productInformation["description"]!
            productGeneralInfo.filePath = productInformation["filePath"]!
            productGeneralInfo.commentID = productInformation["commentID"]!
            self.products.append(productGeneralInfo)
            self.downloadImages(withUrl: productInformation["filePath"]!)
        }
    }
    
    private func downloadImages(withUrl url:String){
        let httpsReference = Storage.storage().reference(forURL: url)
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error : ",error.localizedDescription)
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.productImages.append(image!)
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
}
