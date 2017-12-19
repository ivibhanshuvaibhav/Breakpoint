//
//  AuthService.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 10/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, andName name: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email, "name": name]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Any as! Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
            } else {
                loginComplete(true, nil)
            }
        }
    }
}
