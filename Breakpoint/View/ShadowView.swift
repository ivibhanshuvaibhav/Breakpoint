//
//  ShadowView.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 10/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        shadowView()
        super.awakeFromNib()
    }
    
    func shadowView() {
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

}
