//
//  Model + FriendAddViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/15.
//

import Foundation
import Firebase

struct Friend:Hashable{
    let userId:String
    let userName:String
    let userEmail:String
    let userPhone:String
}

class FriendAddViewModel:ObservableObject{
    @Published var findPhone:String = ""
    @Published var currentUser:Friend = Friend(userId: "", userName: "", userEmail: "", userPhone: "")
    @Published var findedUser:Friend?
    let reference = Firebase.Database.database().reference()
    
    init(){
        findCurrentUser()
    }
    
    func findUser(){
        reference
            .child("User")
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else{return}
                for child in snapshot.children{
                    let childSnapshot = child as! DataSnapshot
                    
                    guard let values = childSnapshot.value as? [String:Any],
                          let phone = values["phone"] as? String else{return}
                    
                    if phone == ("0" + self.findPhone){
                        
                        guard let name = values["name"] as? String,
                              let email = values["email"] as? String else{return}
                        
                        self.findedUser = Friend(userId: childSnapshot.key, userName: name, userEmail: email, userPhone: phone)
                        return
                    }else{
                        self.findedUser = nil
                    }
                }
            }
    }
    
    func findCurrentUser(){
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        
        reference
            .child("User")
            .child(userId)
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else{return}
                guard let values = snapshot.value as? [String:Any] else{return}
                
                guard let name = values["name"] as? String,
                      let email = values["email"] as? String,
                      let phone = values["phone"] as? String else{return}
                
                self.currentUser = Friend(userId: userId, userName: name, userEmail: email, userPhone: phone)
                
            }
    }
    
    func addFriend(){
        guard let currentUID = Firebase.Auth.auth().currentUser?.uid,
              let userId = findedUser?.userId,
              let userName = findedUser?.userName else{return}
        
        reference
            .child("User")
            .child(currentUID)
            .child("friend")
            .updateChildValues([userId:userName])
    }
    
    func addRecommend(){
        guard let userId = findedUser?.userId else{return}
        reference
            .child("User")
            .child(userId)
            .child("recommend")
            .updateChildValues([currentUser.userId:currentUser.userName])
    }
}
