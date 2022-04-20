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
    @Published var friends:[String] = []
    @Published var friendList:[String] = []
    let db = Firestore.firestore().collection("User")
    
    init(){
        self.fetchData()
    }
    
    func fetchData(){
        guard let userId = FirebaseAuth.Auth.auth().currentUser?.uid else{return}
        
        db.document(userId).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot,
                  let data = snapshot.data() else{return}
            
            if let friends = data["friend"] as? [String]{
                self.friendList = friends
                print(self.friendList)
                
                self.fetchUserName()
            }
        }
        
    }
    
    func fetchUserName(){
        self.friends.removeAll()
        self.friendList.forEach { userId in
            db.document(userId).getDocument { snapshot, error in
                guard let userName = snapshot?.get("name") as? String else {return}
                
                self.friends.append(userName)
            }
        }
    }
}
