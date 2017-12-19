//
//  AvatarCell.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 27/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func configureCell(avatarImage: UIImage) {
        self.avatarImage.image = avatarImage
    }
    
    func setBackgroundColor(color: UIColor) {
        self.layer.backgroundColor = color.cgColor
    }
    
    func setUpView() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
