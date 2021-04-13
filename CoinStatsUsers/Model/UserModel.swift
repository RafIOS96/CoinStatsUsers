//
//  UserModel.swift
//  CoinStatsUsers
//
//  Created by Rafayel Aghayan on 06.04.21.
//

import Foundation
import Alamofire
//import RealmSwift

var userListFullInfo = NSMutableArray()
var savedUserListFullInfo = NSMutableArray()

var name: [String: String]?
var picture: [String: String]?
var dob: [String: Any]?
var location: [String: Any]?
var coordinates: [String: Any]?

var indexArray: [Int: Bool] = [:]
var selectedIndex: Int?

// personal info
var userFullName: String?
var userFullAddress: String?
var userPicture: String?
var userEmail: String?
var userPhone: String?
var userGender: String?
var favorite: Bool?

var Results: [Any] = []
var ResultDictinoary: NSDictionary!
var selectedDictionary: NSDictionary!

class UserModel: NSObject {
    
    class func getUserList() {
//      let realm = try! Realm()

        AF.request("https://randomuser.me/api?results=50&page=1", method: .get).responseJSON { (response) in
            if let responseValue = response.value as! [String: Any]? {
                Results = responseValue["results"] as! [Any]
                
                for i in 0..<Results.count {
                    ResultDictinoary = Results[i] as? NSDictionary
                    userListFullInfo.insert(ResultDictinoary ?? [], at: i)
                 
//                    name = ResultDictinoary.object(forKey: "name") as? [String: String]
//
//                    userFullName = (name?["first"] ?? "") + " " + (name?["last"] ?? "")
//
//                    let list = LocalUserInfo()
//                    list.user_FullName = userFullName ?? ""
//
//                    realm.beginWrite()
//                    realm.add(list)
//                    try! realm.commitWrite()
//
//                    render()
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableView"), object: nil)
            }
        }
        
//        func render() {
//            let people = try! realm.objects(LocalUserInfo.self)
//            for person in people {
//                let fullName = person.user_FullName
//            }
//        }
    }
    
    
    class func setUserData(fromMutableArray: NSMutableArray, indexPath: Int) {
                
        selectedDictionary = fromMutableArray[indexPath] as? NSDictionary
        
        name = selectedDictionary.object(forKey: "name") as? [String: String]
        
        location = selectedDictionary.object(forKey: "location") as? [String: Any]
        
        picture = selectedDictionary.object(forKey: "picture") as? [String: String]
        
        dob = selectedDictionary.object(forKey: "dob") as? [String: Any]
        
        userEmail = selectedDictionary.object(forKey: "email") as? String ?? ""

        userPhone = selectedDictionary.object(forKey: "phone") as? String ?? ""

        userFullName = (name?["first"] ?? "") + " " + (name?["last"] ?? "")

        userFullAddress = ((location?["country"] ?? "") as? String)! + ", " + ((location?["state"] ?? "") as? String)! + ", " + ((location?["city"] ?? "") as? String)!

        userPicture = picture?["medium"] ?? ""

        userGender = selectedDictionary.object(forKey: "gender") as? String ?? ""
    }
}

//class LocalUserInfo: Object {
//    @objc dynamic var user_FullName: String = ""
//    @objc dynamic var user_FullAddress: String = ""
//    @objc dynamic var user_Email: String = ""
//    @objc dynamic var user_Phone: String = ""
//    @objc dynamic var user_Gender: String = ""
//}
