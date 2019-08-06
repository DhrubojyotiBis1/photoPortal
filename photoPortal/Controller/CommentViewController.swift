//
//  CommentViewController.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 05/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    var selectedImage = UIImage()
    var commentID = Int()
    var comments = [String]()
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentTextFeild: UITextField!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commetImageView: UIImageView!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.getDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    private func configure(){
        SVProgressHUD.show()
        self.sendButton.isEnabled = false
        self.sendButton.layer.cornerRadius = 5
        self.commentTextFeild.layer.cornerRadius = 5
        self.commetImageView.image = self.selectedImage
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillAppear),name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func changeConstrain(withKeybordHight hight:CGFloat){
        self.bottomConstrain.constant = hight
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        var keyboardHeight = CGFloat()
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        self.changeConstrain(withKeybordHight: keyboardHeight)
        
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification?) {
        self.bottomConstrain.constant = 0
    }
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        self.sendButton.isEnabled = false
        self.commentTextFeild.endEditing(true)
        self.upload(comment: self.commentTextFeild.text!) { (SUCESS) in
            if SUCESS != true {
                SVProgressHUD.showError(withStatus: messages().somethingWentWrong)
            }else{
                self.commentTextFeild.text! = ""
            }
        }
        self.sendButton.isEnabled = true
    }

}

extension CommentViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        cell.comment.text! = self.comments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    
    
    
}

extension CommentViewController{
    private func getDate(){
        let dateBaseRef = Database.database().reference().child("photoPortalProductComment")
        dateBaseRef.observe(.value) { (DataSnapshot) in
            if DataSnapshot.hasChildren() != true{
                SVProgressHUD.dismiss()
                self.sendButton.isEnabled = true
            }
        }
        dateBaseRef.observe(.childAdded) { (DataSnapshot) in
            let comment = DataSnapshot.value as! [String:String]
            if comment["commentID"]! == "\(self.commentID)"{
                self.comments.append(comment["comment"]!)
                self.commentTableView.reloadData()
                self.sendButton.isEnabled = true
                SVProgressHUD.dismiss()
            }else{
                self.sendButton.isEnabled = true
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func upload(comment:String,completion: @escaping((_ SCUESS:Bool)->())){
        let dateBaseRef = Database.database().reference().child("photoPortalProductComment")
        let commentToUpload = ["comment":comment,"commentID":"\(self.commentID)"]
        dateBaseRef.childByAutoId().setValue(commentToUpload)
        completion(true)
    }
}

