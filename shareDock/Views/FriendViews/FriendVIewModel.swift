//
//  FriendVIewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/14.
//

import Foundation
import Firebase

struct friend:Hashable{
    var userName:String
    var userPhone:String
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
            .observe(.childAdded) { snapshot in
                guard let values = snapshot.value as? [String:Any] else {return}
                
            }
        
    }
}
