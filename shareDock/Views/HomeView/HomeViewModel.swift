//
//  HomeViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel:ObservableObject{
    @Published var parties:[party] = []
    var partyList:[String] = []
    let db = Firestore.firestore()
    init(){
        ObservePartyList {
            self.ObserveData()
        }
    }
    
    func ObservePartyList(completion:@escaping()->Void){
        self.parties.removeAll()
        self.partyList.removeAll()
        
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        
        Firebase.Database.database().reference()
            .child("User")
            .child(userId)
            .child("Party")
            .observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children{
                    let childSnap = child as! DataSnapshot
                    guard let uuid = childSnap.value as? String else{return}
                    self.partyList.append(uuid)
                }
                
                completion()
            }
    }
    
    func ObserveData(){
        self.partyList.forEach{
            db.collection($0).document($0).getDocument(as: party.self) { result in
                switch result{
                case .success(let party):
                    self.parties.append(party)
                    print(self.parties)
                case .failure(let error):
                    print("Error in set Data ::: \(error.localizedDescription)")
                }
            }
        }
    }
}
