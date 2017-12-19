//
//  LoginVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 06/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    @IBOutlet weak var enterEmailLabel: UILabel!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        enterEmailLabel.isHidden = true
        enterPasswordLabel.isHidden = true
        let email = emailField.text!
        let password = passwordField.text!
        if email == "" || password == "" {
            if email == "" {
                enterEmailLabel.isHidden = false
            }
            if password == "" {
                enterPasswordLabel.isHidden = false
            }
        } else {
            AuthService.instance.loginUser(withEmail: email, andPassword: password, loginComplete: { (success, loginError) in
                if success {
                    print("Successfully logged in user.")
                    let userVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(userVC, animated: true, completion: nil)
                } else {
                    let error: NSError = loginError! as NSError
                    if error.code == AuthErrorCode.networkError.rawValue {
                        SVProgressHUD.setContainerView(self.mainView)
                        SVProgressHUD.setBackgroundColor(UIColor.cyan)
                        SVProgressHUD.showError(withStatus: "Network Error")
                    } else if error.code == AuthErrorCode.userNotFound.rawValue {
                        let userNotFoundPopup = UIAlertController(title: "User Not Found", message: "Do you want to sign up?", preferredStyle: .alert)
                        let createUserAction = UIAlertAction(title: "Sign Up", style: .default) { (buttonTapped) in
                            let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                            self.present(registerVC, animated: true, completion: nil)
                        }
                        userNotFoundPopup.addAction(createUserAction)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        userNotFoundPopup.addAction(cancelAction)
                        self.present(userNotFoundPopup, animated: true, completion: nil)
                    } else if error.code == AuthErrorCode.invalidEmail.rawValue {
                        self.enterEmailLabel.text = "please enter valid email"
                        self.enterEmailLabel.isHidden = false
                    } else if error.code == AuthErrorCode.wrongPassword.rawValue {
                        self.enterPasswordLabel.text = "wrong password"
                        self.enterPasswordLabel.isHidden = false
                    }
                    print(String(describing: error.localizedDescription))
                }
            })
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
}
