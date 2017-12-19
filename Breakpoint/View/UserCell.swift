//
//  UserCell.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 12/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: AvatarImage!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false
    
    func configureCell(profileImage image: String, email: String, isSelected: Bool) {
        self.profileImage.setAvatar(imageName: image)
        self.emailLabel.text = email
        if isSelected {
            self.checkImage.isHidden = false
            showing = true
        } else {
            self.checkImage.isHidden = true
            showing = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                checkImage.isHidden = false
                showing = true
            } else {
                checkImage.isHidden = true
                showing = false
            }
        }
    }

}
