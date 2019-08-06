//
//  WelcomeViewController.swift
//  photoPortal
//
//  Created by Dhrubojyoti on 03/08/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configure()
    }
    
    private func configure(){
        navigationController?.navigationBar.isHidden = true
        self.loginButton.layer.cornerRadius = 5
        self.registerButton.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func logInbuttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogInVC", sender: nil)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegisterVC", sender: nil)
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
