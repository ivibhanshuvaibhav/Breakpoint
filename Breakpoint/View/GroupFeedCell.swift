//
//  GroupFeedCell.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 15/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: AvatarImage!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func configureCell(profileImage: String, email: String, content: String) {
        self.profileImage.setAvatar(imageName: profileImage)
        self.emailLabel.text = email
        self.contentLabel.text = content
    }
    
}
