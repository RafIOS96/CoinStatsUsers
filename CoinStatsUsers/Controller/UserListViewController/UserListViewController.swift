//
//  UserListViewController.swift
//  CoinStatsUsers
//
//  Created by Rafayel Aghayan on 07.04.21.
//

import UIKit
//import RealmSwift

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)),
                                               name: Notification.Name(rawValue: "reloadTableView"),
                                               object: nil)
        UserModel.getUserList()
                
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        savedUserListFullInfo.removeAllObjects()
        
        self.navigationItem.title = "Users"
        
        if let selectedIndexPath = self.userListTableView.indexPathForSelectedRow {
            self.userListTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
        userListTableView.reloadData()
    }
    
    @objc func reloadTable(_ notification: Notification) {
        self.userListTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListFullInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserInfoTableViewCell

        UserModel.setUserData(fromMutableArray: userListFullInfo, indexPath: indexPath.row)
        
        cell.userEmail?.text = userEmail
        
        cell.userPhone.text = userPhone
        
        cell.fullName.text = userFullName
        
        cell.fullAddress.text = userFullAddress
        
        cell.profileImage.downloaded(from: userPicture ?? "")
        
        if userGender == "male" {
            cell.genderImage.image = UIImage(named:"male")
        } else {
            cell.genderImage.image = UIImage(named:"female")
        }
     
        if indexArray[indexPath.row] == false {
            cell.favoriteButton.isSelected = false
        } else if indexArray[indexPath.row] == true {
            cell.favoriteButton.isSelected = true
        } else {
            cell.favoriteButton.isSelected = false
        }
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(self.favoriteButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserModel.setUserData(fromMutableArray: userListFullInfo, indexPath: indexPath.row)
        
        selectedIndex = indexPath.row
        
        favorite = indexArray[selectedIndex!]
        
        let toUserScreen = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewControllerID") as! UserInfoViewController
        self.navigationController?.pushViewController(toUserScreen, animated: true)
    }    
   
    @objc func favoriteButtonClicked(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
            indexArray[sender.tag] = false
        } else {
            sender.isSelected = true
            indexArray[sender.tag] = true
        }
    }
}

