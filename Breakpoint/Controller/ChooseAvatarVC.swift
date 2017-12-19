//
//  ChooseAvatarVC.swift
//  Breakpoint
//
//  Created by Vibhanshu Vaibhav on 27/11/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import Firebase

enum AvatarType: String {
    case dark = "dark"
    case light = "light"
}

class ChooseAvatarVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    var avatarType: AvatarType = AvatarType.dark

    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        } else {
            avatarType = .light
        }
        collectionView.reloadData()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChooseAvatarVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell else { return UICollectionViewCell() }
        if avatarType == .dark {
            cell.configureCell(avatarImage: UIImage(named: "\(avatarType.rawValue)\(indexPath.item)")!)
            cell.setBackgroundColor(color: UIColor.lightGray)
        } else {
            cell.configureCell(avatarImage: UIImage(named: "\(avatarType.rawValue)\(indexPath.row)")!)
            cell.setBackgroundColor(color: UIColor.darkGray)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let avatarName = "\(avatarType.rawValue)\(indexPath.row)"
        let userData = ["profileImage": avatarName]
        DataService.instance.updateDBUser(uid: (Auth.auth().currentUser?.uid)!, userData: userData as Any as! Dictionary<String, Any>)
        dismiss(animated: true, completion: nil)
    }
}
