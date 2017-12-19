//
//  GroupFeedVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 15/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase
import IHKeyboardAvoiding

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var membersTextView: UITextView!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var group: Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLabel.text = group?.groupTitle
        DataService.instance.getEmails(forGroup: group!, handler: { (returnedEmails) in
            self.membersTextView.text = returnedEmails.joined(separator: ", ")
        })
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroupMessages(desiredGroup: self.group!) { (returnedMessagesArray) in
                self.groupMessages = returnedMessagesArray
                self.tableView.reloadData()
                if self.groupMessages.count > 1 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.groupMessages.count - 1, section: 0) , at: .middle, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        IHKeyboardAvoiding.KeyboardAvoiding.avoidingView = sendButtonView
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, sendComplete: { (status) in
                if status {
                    messageTextField.text = ""
                    messageTextField.isEnabled = true
                    sendButton.isEnabled = true
                }
            })
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }
    
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell") as? GroupFeedCell else { return UITableViewCell() }
        let message = groupMessages[indexPath.row]
        
        DataService.instance.getUsernameAndAvatar(forUID: message.senderId) { (email, profileImage) in
            cell.configureCell(profileImage: profileImage, email: email, content: message.content)
        }
        return cell
    }
    
}

