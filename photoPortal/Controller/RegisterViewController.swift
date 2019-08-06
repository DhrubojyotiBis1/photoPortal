//
//  RegisterViewController.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 03/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configure()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        self.registerNewUser()
    }
    
    private func configure(){
        self.registerButton.layer.cornerRadius = 5
    }
    private func registerNewUser(){
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { authResult, error in
            SVProgressHUD.dismiss()
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }else{
                self.performSegue(withIdentifier: "goToPortalVC", sender: nil)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
