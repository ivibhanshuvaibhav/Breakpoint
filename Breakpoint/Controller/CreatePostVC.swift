//
//  CreatePostVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 11/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImage: AvatarImage!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.getUsernameAndAvatar(forUID: (Auth.auth().currentUser?.uid)!) { (email, profileImage) in
            self.emailLabel.text = Auth.auth().currentUser?.email
            self.profileImage.setAvatar(imageName: profileImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageText.delegate = self
        sendButton.bindToKeyboard()
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageText.text != nil && messageText.text != "Say something here..." {
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageText.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: { (isComplete) in
                if isComplete {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Message not uploaded to server.")
                    self.sendButton.isEnabled = true
                }
            })
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if messageText.text != "Say something here..." {
            let discardPopup = UIAlertController(title: "Discard?", message: "Are you sure you want to discard?", preferredStyle: .actionSheet)
            let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (buttonTapped) in
                self.dismiss(animated: true, completion: nil)
            }
            discardPopup.addAction(discardAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            discardPopup.addAction(cancelAction)
            present(discardPopup, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
