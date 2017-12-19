//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 06/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
    }

    @IBAction func facebookSignInButtonPressed(_ sender: Any) {
    }
    @IBAction func googleSignInButtonPressed(_ sender: Any) {
    }
    
    @IBAction func signInWithEmailButtonPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        present(loginVC, animated: true, completion: nil)
    }
    
}
