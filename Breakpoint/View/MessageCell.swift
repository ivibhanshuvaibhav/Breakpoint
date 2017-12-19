//
//  MessageCell.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 24/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var reciever: UILabel!
    @IBOutlet weak var message: UILabel!
    
    func configureCell(reciever: String, message: String) {
        self.reciever.text = reciever
        self.message.text = message
    }
    
}
