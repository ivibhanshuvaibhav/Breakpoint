//
//  GroupsVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 02/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import SVProgressHUD

class GroupsVC: UIViewController {

    @IBOutlet weak var groupsTableView: UITableView!
    
    var groupsArray = [Group]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                SVProgressHUD.dismiss(completion: {
                    self.groupsTableView.reloadData()
                    self.groupsTableView.isHidden = false
                    if self.groupsArray.count > 1 {
                        self.groupsTableView.scrollToRow(at: IndexPath.init(row: 1, section: 0) , at: .middle, animated: true)
                    }
                })
            }
        }
    }
    
}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupCell else { return UITableViewCell() }
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDesc, memberCount: group.memberCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as! GroupFeedVC
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
        presentDetail(groupFeedVC)
    }
    
}
