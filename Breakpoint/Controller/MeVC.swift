//
//  MeVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 11/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    @IBOutlet weak var profileImage: AvatarImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var deleteStatusButton: UIButton!
    
    var userMessages = [UserMessage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLabel.text = Auth.auth().currentUser?.email
        DataService.instance.getCurrentUserInfo { (user) in
            let name = user.childSnapshot(forPath: "name").value as! String
            self.nameLabel.text = name
            if user.childSnapshot(forPath: "status").exists() {
                let status = user.childSnapshot(forPath: "status").value as! String
                self.statusLabel.text = status
                self.deleteStatusButton.isHidden = false
            } else {
                self.deleteStatusButton.isHidden = true
            }
            if user.childSnapshot(forPath: "profileImage").exists() {
                let avatarImage = user.childSnapshot(forPath: "profileImage").value as! String
                self.profileImage.setAvatar(imageName: avatarImage)
            }
        }
        DataService.instance.getMessages(forUID: (Auth.auth().currentUser?.uid)!) { (returnedUserMessages) in
            self.userMessages = returnedUserMessages
            self.tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    @IBAction func changeImageButtonPressed(_ sender: Any) {
        let chooseAvatarVC = storyboard?.instantiateViewController(withIdentifier: "ChooseAvatarVC") as! ChooseAvatarVC
        present(chooseAvatarVC, animated: true, completion: nil)
    }
    
    @IBAction func statusButtonPressed(_ sender: Any) {
        let statusAlert = UIAlertController(title: "Enter Status", message: "Put something cool as your status", preferredStyle: .alert)
        statusAlert.addTextField(configurationHandler: nil)
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { (submit) in
            if let field = statusAlert.textFields?[0] {
                if field.text != "" {
                    self.statusLabel.text = field.text
                    let userData = ["status": field.text]
                    DataService.instance.updateDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userData as Any as! Dictionary<String, Any>)
                    self.deleteStatusButton.isHidden = false
                } 
            }
        }
        statusAlert.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        statusAlert.addAction(cancelAction)
        
        present(statusAlert, animated: true, completion: nil)
    }

    @IBAction func deleteStatusButtonPressed(_ sender: Any) {
        statusLabel.text = "*no status*"
        deleteStatusButton.isHidden = true
        let userData = ["status": nil] as [String : Any?]
        DataService.instance.updateDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userData as Any as! Dictionary<String, Any>)
        
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                print("Successfully signed out.")
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                self.present(authVC, animated: true, completion: nil)
            } catch {
                print("Could not log out user.")
                print(error.localizedDescription)
            }
        }
        logoutPopup.addAction(logoutAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        logoutPopup.addAction(cancelAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}

extension MeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageCell else { return UITableViewCell() }
        let userMessage = userMessages[indexPath.row]
        cell.configureCell(reciever: userMessage.reciever, message: userMessage.message)
        return cell
    }
    
    
}
