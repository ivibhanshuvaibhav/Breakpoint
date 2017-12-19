//
//  RegisterVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 16/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterVC: UIViewController {

    @IBOutlet weak var nameField: InsetTextField!
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    @IBOutlet weak var enterNameLabel: UILabel!
    @IBOutlet weak var enterEmailLabel: UILabel!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        enterNameLabel.isHidden = true
        enterEmailLabel.isHidden = true
        enterPasswordLabel.isHidden = true
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        if name == "" || email == "" || password == "" {
            if name == "" {
                enterNameLabel.isHidden = false
            }
            if email == "" {
                enterEmailLabel.isHidden = false
            }
            if password == "" {
                enterPasswordLabel.isHidden = false
            }
        } else {
            AuthService.instance.registerUser(withEmail: email, andPassword: password, andName: name, userCreationComplete: { (success, registrationError) in
                if success {
                    print("Successfully created user.")
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
                            }
                            print(String(describing: error.localizedDescription))
                        }
                    })
                    
                } else {
                    let error: NSError = registrationError! as NSError
                    if error.code == AuthErrorCode.networkError.rawValue {
                        SVProgressHUD.setContainerView(self.mainView)
                        SVProgressHUD.setBackgroundColor(UIColor.cyan)
                        SVProgressHUD.showError(withStatus: "Network Error")
                    } else if error.code == AuthErrorCode.invalidEmail.rawValue {
                        self.enterEmailLabel.text = "enter valid email"
                        self.enterEmailLabel.isHidden = false
                    } else if error.code == AuthErrorCode.weakPassword.rawValue {
                        self.enterPasswordLabel.text = "password is weak"
                        self.enterPasswordLabel.isHidden = false
                    } else if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        self.enterEmailLabel.text = "email already in use"
                        self.enterEmailLabel.isHidden = false
                    }
                    print(String(describing: error.localizedDescription))
                }
            })
        }
    }
    
    @IBAction func goToLoginVCButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterVC: UITextFieldDelegate {
    
}
