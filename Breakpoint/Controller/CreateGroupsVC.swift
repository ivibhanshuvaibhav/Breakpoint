//
//  CreateGroupsVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 12/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var titleField: InsetTextField!
    @IBOutlet weak var descriptionField: InsetTextField!
    @IBOutlet weak var emailSearchField: InsetTextField!
    @IBOutlet weak var groupMemberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var emailArray = [String]()
    var avatarArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchField.delegate = self
        emailSearchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
        if emailSearchField.text! == "" {
            emailArray = []
            avatarArray = []
            tableView.reloadData()
        } else {
            DataService.instance.REF_USERS.observe(.value, with: { (snapshot) in
                DataService.instance.getEmailAndAvatar(forSearchQuery: self.emailSearchField.text!, handler: { (returnedEmailArray, returnedAvatarArray) in
                    self.emailArray = returnedEmailArray
                    self.avatarArray = returnedAvatarArray
                    self.tableView.reloadData()
                })
            })
            
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if titleField.text != "" && descriptionField.text != "" {
            DataService.instance.getIds(forUsernames: chosenUserArray, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withTitle: self.titleField.text!, andDescription: self.descriptionField.text!, forUserIds: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("Could not create group.")
                    }
                })
            })
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileImage = avatarArray[indexPath.row]
        
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profileImage: profileImage, email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(profileImage: profileImage, email: emailArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenUserArray.contains(cell.emailLabel.text!) {
            chosenUserArray.append(cell.emailLabel.text!)
            groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            doneButton.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text! })
            if chosenUserArray.count >= 1 {
                groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            } else {
                groupMemberLabel.text = "add people to your group"
                doneButton.isHidden = true
            }
        }
    }
    
}

extension CreateGroupsVC: UITextFieldDelegate {
    
}
