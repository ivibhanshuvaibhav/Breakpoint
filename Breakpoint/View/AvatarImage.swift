//
//  AvatarImage.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 28/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class AvatarImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.layer.bounds.size.width / 2
    }
    
    func setAvatar(imageName: String) {
        if imageName == DEFAULT_PROFILE_IMAGE {
            self.image = UIImage(named: DEFAULT_PROFILE_IMAGE)
            self.layer.backgroundColor = UIColor.clear.cgColor
        } else {
            if imageName.contains("dark") {
                self.layer.backgroundColor = UIColor.lightGray.cgColor
            } else {
                self.layer.backgroundColor = UIColor.darkGray.cgColor
            }
            self.image = UIImage(named: imageName)
        }
    }

}
