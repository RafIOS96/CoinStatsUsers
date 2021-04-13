//
//  SavedUserViewController.swift
//  CoinStatsUsers
//
//  Created by  AskMe on 12.04.21.
//

import UIKit

class SavedUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var savedUserList: UITableView!
    
    var x = 0
    var numberArray: [Any] = []
    var defavoriteTag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.savedUserList.delegate = self
        self.savedUserList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        x = 0
        numberArray.removeAll()
        
        if indexArray.count != 0 {
            
            for (key, value) in indexArray {
                if value == true {
                    selectedDictionary = Results[key] as? NSDictionary
                    savedUserListFullInfo.insert(selectedDictionary ?? [], at: x)
                    x+=1
                    numberArray.append(key)
                }
            }
        }
        savedUserList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedUserListFullInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedUserTableViewCell

        UserModel.setUserData(fromMutableArray: savedUserListFullInfo, indexPath: indexPath.row)
        
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
     
        if indexArray[indexPath.row] == true {
            cell.favoriteButton.isSelected = false
        } else if indexArray[indexPath.row] == false {
            cell.favoriteButton.isSelected = false
        } else {
            cell.favoriteButton.isSelected = false
        }
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(self.favoriteButtonClicked), for: .touchUpInside)
        return cell
    }
    
    @objc func favoriteButtonClicked(_ sender: UIButton) {
        defavoriteTag = numberArray[sender.tag] as? Int
        
        if sender.isSelected
        {
            sender.isSelected = false
            indexArray[defavoriteTag!] = true
        } else {
            sender.isSelected = true
            indexArray[defavoriteTag!] = false
        }
    }
}
