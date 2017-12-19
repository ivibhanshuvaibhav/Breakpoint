//
//  UserMessage.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 24/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import Foundation

class UserMessage {
    private var _message: String
    private var _reciever: String
    
    var message: String {
        return _message
    }
    
    var reciever: String {
        return _reciever
    }
    
    init(message: String, reciever: String) {
        self._message = message
        self._reciever = reciever
    }
}
