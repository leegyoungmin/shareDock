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
    var partyIdList:[String] = []
    let db = Firestore.firestore()
    
    init(){
        fetchUserPartyId()
    }
    
    
    func fetchUserPartyId(){
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        db.collection("User").document(userId).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot,
                  let partyIds = snapshot.get("party") as? [String] else{return}
            
            self.partyIdList = partyIds
            
            self.fetchParty()
        }
    }
    
    func fetchParty(){
        self.partyIdList.forEach { partyId in
            
            if !parties.contains(where: {$0.id == partyId}){
                db.collection("Party").document(partyId).addSnapshotListener { snapshot, error in
                    guard let snapshot = snapshot else{return}
                    
                    do{
                        let party = try snapshot.data(as: party.self)
                        self.parties.append(party)
                    } catch {
                        print("Error in fetch Party ::: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
