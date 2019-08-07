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

class PortalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,AddProductViewControllerDelegate{
    func AddProductViewControllerResponse(didSelectImage: Bool) {
        self.isImageUploaded = didSelectImage
    }
    
    var documentId = [String]()
    var isImageUploaded = false
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var commentID = Int()
    var selectedDocumentId = String()
    var image = UIImage()
    var products = [productGeneralnformation]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isImageUploaded{
            getData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portalTableViewCell", for: indexPath) as! PortalTableViewCell
        cell.productGeneralnformation = self.products[indexPath.row]
        cell.productGeneralnformation = self.products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.image = self.products[indexPath.row].image
        self.commentID = Int(self.products[indexPath.row].commentID)!
        self.selectedDocumentId = documentId[indexPath.row]
        performSegue(withIdentifier: "goToCommentVC", sender: nil)
    }
    
    private func configure(){
        
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
            distination.delegate = self
            distination.pickedImage = self.selectedImage
            distination.commentID = self.products.count + 1
        }else if segue.identifier == "goToCommentVC"{
            let destination = segue.destination as! CommentViewController
            destination.commentID = Int("\(self.commentID)")!
            destination.image = self.image
            destination.documentId = self.selectedDocumentId
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
        self.products.removeAll()
        SVProgressHUD.show()
        let dataBaseRef = Firestore.firestore()
        dataBaseRef.collection("Products").getDocuments(){ (querySnapshot, err) in
            if querySnapshot?.count == 0 {
                SVProgressHUD.dismiss()
                return
            }
            if let err = err {
                print("Error getting documents: \(err)")
                SVProgressHUD.showError(withStatus: messages().somethingWentWrong)
                return
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let productInformation = document.data() as! [String:String]
                    let productGeneralInfo = productGeneralnformation(productName: productInformation["name"]!, catagory: productInformation["catagory"]!, discription: productInformation["description"]!, filePath: productInformation["filePath"]!, commentID:  productInformation["commentID"]!)
                    self.documentId.append(document.documentID)
                    self.products.append(productGeneralInfo)
                }
                
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
        
        
    
}
