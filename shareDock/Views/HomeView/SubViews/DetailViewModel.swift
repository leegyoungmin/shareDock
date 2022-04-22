//
//  DetailViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct partyUser:Codable,Hashable{
    let userId:String
    let userName:String
    var payUser:Bool = false
}

class DetailViewModel:ObservableObject{
    @Published var userNameList:[partyUser] = []
    let party:party
    let db = Firestore.firestore()

    init(party:party){
        self.party = party
        
        self.fetchData()
    }
    
    func fetchData(){
        
        self.party.members.forEach { userId in
            db.collection("User").document(userId).getDocument { [weak self] snapshot, error in
                guard let self = self else{return}
                guard let userName = snapshot?.get("name") as? String else{return}
                
                if userId == self.party.payer{
                    self.userNameList.append(partyUser(userId: userId, userName: userName,payUser: true))
                }else{
                    self.userNameList.append(partyUser(userId: userId, userName: userName))
                }
            }
        }
        

    }
}
