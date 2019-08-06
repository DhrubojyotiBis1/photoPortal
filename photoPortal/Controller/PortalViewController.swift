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
    var commentID = Int()
    var image = UIImage()
    var products = [productGeneralnformation]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portalTableViewCell", for: indexPath) as! PortalTableViewCell
        cell.productGeneralnformation = self.products[indexPath.row]
        self.products[indexPath.row] = (cell.productGeneralnformation!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.image = self.products[indexPath.row].image
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
            distination.commentID = self.products.count + 1
        }else if segue.identifier == "goToCommentVC"{
            let destination = segue.destination as! CommentViewController
            destination.commentID = self.commentID
            destination.image = self.image
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
            let productInformation = DataSnapshot.value as! [String:String]
            let productGeneralInfo = productGeneralnformation(productName: productInformation["name"]!, catagory: productInformation["catagory"]!, discription: productInformation["description"]!, filePath: productInformation["filePath"]!, commentID:  productInformation["commentID"]!)
            self.products.append(productGeneralInfo)
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
}
