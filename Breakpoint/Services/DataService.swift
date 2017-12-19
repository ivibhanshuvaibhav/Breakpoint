//
//  DataService.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 05/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDBUser(uid: String, userData: Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsernameAndAvatar(forUID uid: String, handler: @escaping (_ username: String, _ avatarImage: String) -> ()) {
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if user.key == uid {
                    if user.childSnapshot(forPath: "profileImage").exists() {
                        let avatarImage = user.childSnapshot(forPath: "profileImage").value as! String
                        handler(user.childSnapshot(forPath: "email").value as! String, avatarImage)
                    } else {
                        handler(user.childSnapshot(forPath: "email").value as! String, DEFAULT_PROFILE_IMAGE)
                    }
                }
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: (_ status: Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                
                messageArray.append(message)
            }
            
            handler(messageArray)
        }
    }
    
    func getAllGroupMessages(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in groupMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }
    
    func getEmailAndAvatar(forSearchQuery query: String, handler: @escaping (_ emailArray: [String], _ avatarArray: [String]) -> ()) {
        var emailArray = [String]()
        var avatarArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                    if user.childSnapshot(forPath: "profileImage").exists() {
                        let avatarImage = user.childSnapshot(forPath: "profileImage").value as! String
                        avatarArray.append(avatarImage)
                    } else {
                        avatarArray.append(DEFAULT_PROFILE_IMAGE)
                    }
                }
            }
            handler(emailArray, avatarArray)
        }
    }
    
    func getIds(forUsernames username: [String], handler: @escaping (_ uidArray:[String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var idArray = [String]()
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if username.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmails(forGroup group: Group, handler: @escaping (_ email: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if group.members.contains(user.key){
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    
                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
    func getCurrentUserInfo(handler: @escaping (_ user: DataSnapshot) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == Auth.auth().currentUser?.uid {
                    handler(user)
                }
                
            }
        }
    }
    
    func getMessages(forUID uid: String, handler: @escaping (_ messages: [UserMessage]) -> ()) {
        var userMessages = [UserMessage]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for message in feedMessageSnapshot {
                let sender = message.childSnapshot(forPath: "senderId").value as! String
                if sender == uid {
                    let content = message.childSnapshot(forPath: "content").value as! String
                    let userMessage = UserMessage(message: content, reciever: "Feed")
                    userMessages.append(userMessage)
                }
            }
        }
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                
                if memberArray.contains(uid) {
                    guard let messagesArray = group.childSnapshot(forPath: "messages").children.allObjects as? [DataSnapshot] else { return }
                    for message in messagesArray {
                        let sender = message.childSnapshot(forPath: "senderId").value as! String
                        if sender == uid {
                            let reciever = group.childSnapshot(forPath: "title").value as! String
                            let content = message.childSnapshot(forPath: "content").value as! String
                            let userMessage = UserMessage(message: content, reciever: reciever)
                            userMessages.append(userMessage)
                        }
                    }
                }
            }
            handler(userMessages)
        }
    }
}
