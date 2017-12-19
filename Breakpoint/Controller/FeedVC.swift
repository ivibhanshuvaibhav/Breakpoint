//
//  FeedVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 02/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.show()
        DataService.instance.REF_FEED.observe(.value) { (snapshot) in
            DataService.instance.getAllFeedMessages { (returnedMessageArray) in
                self.messageArray = returnedMessageArray.reversed()
                SVProgressHUD.dismiss(completion: {
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    if self.messageArray.count > 1 {
                        self.tableView.scrollToRow(at: IndexPath.init(row: 1, section: 0) , at: .middle, animated: true)
                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 100
    }

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return UITableViewCell() }
        let message = messageArray[indexPath.row]
        
        DataService.instance.getUsernameAndAvatar(forUID: message.senderId, handler: { (email, profileImage) in
            cell.configureCell(profileImage: profileImage, email: email, content: message.content)
        })
        return cell
    }
    
}
