//
//  DetailViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class DetailViewModel:ObservableObject{
    @Published var userNameList:[String] = []
    let userIds:[String]
    let db = Firestore.firestore().collection("User")
    init(userIds:[String]){
        self.userIds = userIds
        
        fetchUserNames()
    }
    
    
    func fetchUserNames(){
        self.userIds.forEach { userId in
            db.document(userId).getDocument { snapshot, error in
                guard let snapshot = snapshot,
                      let userName = snapshot.get("name") as? String else{return}
                
                self.userNameList.append(userName)
                
            }
        }

    }
}
