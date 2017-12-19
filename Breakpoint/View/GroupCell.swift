//
//  GroupCell.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 14/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLabel.text = title
        self.groupDescriptionLabel.text = description
        self.memberCountLabel.text = "\(memberCount) members"
    }
    
    
}
