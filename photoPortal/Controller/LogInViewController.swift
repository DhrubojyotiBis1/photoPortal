//
//  LogInViewController.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 03/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configure()
    }
    private func configure(){
        self.logInButton.layer.cornerRadius = 5
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        self.login()
    }
    
    private func login(){
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { [weak self] user, error in
            guard self != nil else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                SVProgressHUD.showError(withStatus:messages().emailOrPasswordWrong)
                return
            }else{
                self!.performSegue(withIdentifier: "goToPortalVC", sender: nil)
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
