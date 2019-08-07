//
//  AddProductViewController.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 04/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import SVProgressHUD

protocol AddProductViewControllerDelegate
{
    func AddProductViewControllerResponse(didSelectImage: Bool)
}

class AddProductViewController: UIViewController {
    
    var delegate:AddProductViewControllerDelegate?
    @IBOutlet weak var saveBUtton: UIBarButtonItem!
    var pickedImage = UIImage()
    let imagePicker = UIImagePickerController()
    var commentID = Int()
    let ref = Database.database().reference()

    @IBOutlet weak var discriptionTextField: UITextField!
    @IBOutlet weak var catogoryTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var addProductImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configure()
    }
    
    private func configure(){
        SVProgressHUD.dismiss()
        self.addProductImageView.image = pickedImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        self.addProductImageView.isUserInteractionEnabled = true
        self.addProductImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageViewTapped() {
        self.pickImage()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        self.saveBUtton.isEnabled = false
        SVProgressHUD.show()
        self.upload(image: self.pickedImage) { (url) in
            if let url = url{
                self.upload(name: self.productNameTextField.text!, catagory: self.catogoryTextField.text!, description: self.discriptionTextField.text!, pathFile: url, completion: { (sucess) in
                    if sucess != nil{
                        SVProgressHUD.showSuccess(withStatus: messages().productUploaded)
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.AddProductViewControllerResponse(didSelectImage: true)
                    }else{
                        self.delegate?.AddProductViewControllerResponse(didSelectImage: false)
                    }
                })

            }else{
                SVProgressHUD.showError(withStatus: messages().somethingWentWrong)
                self.delegate?.AddProductViewControllerResponse(didSelectImage: false)
            }
            self.saveBUtton.isEnabled = true
        }
    }

}

extension AddProductViewController:UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    private func pickImage(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.pickedImage = tempImage
        self.addProductImageView.image = pickedImage
    }
    
}

extension AddProductViewController{
    private func upload(image:UIImage,completion: @escaping((_ url:URL?)->())){
        let storegeRef = Storage.storage().reference().child("Image-\(productNameTextField.text!)-\(arc4random())")
        let imageData = image.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storegeRef.putData(imageData!, metadata: metaData) { (metaData, error) in
            if error == nil{
                print("Uploaded")
                storegeRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            }else{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    private func upload(name:String,catagory:String,description:String,pathFile:URL,completion: @escaping((_ SUCESS:String?)->())){
        let productData = ["name":name,"catagory":catagory,"description":description,"filePath":"\(pathFile)","commentID":"\(self.commentID)"]
       /* let ref = Database.database().reference().child("photoPortalProductInformation")
        ref.childByAutoId().setValue(productData)*/
        
        let dataBaseRef = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = dataBaseRef.collection("Products").addDocument(data:productData) { err in
            if let err = err {
                completion(nil)
                print("Error adding document: \(err)")
            } else {
                completion("DONE")
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}
