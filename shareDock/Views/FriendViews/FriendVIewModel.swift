//
//  FriendVIewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/14.
//

import Foundation
import Firebase

struct friend:Hashable{
    var userId:String
    var userName:String
}

class FriendViewModel:ObservableObject{
    @Published var friends:[friend] = []
    
    init(){
        self.fetchData()
    }
    
    func fetchData(){
        guard let userId = FirebaseAuth.Auth.auth().currentUser?.uid else{return}
        
        Firebase.Database.database().reference()
            .child("User")
            .child(userId)
            .child("friend")
            .observe(.childAdded) { snapshot in
                let userId = snapshot.key
                guard let name = snapshot.value as? String else{return}
                
                self.friends.append(friend(userId: userId, userName: name))
            }
        
    }
}
