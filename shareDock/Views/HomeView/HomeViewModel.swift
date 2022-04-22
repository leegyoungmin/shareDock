//
//  HomeViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

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
                
                db.collection("Party").addSnapshotListener { querySnapshot, error in
                    guard let changes = querySnapshot?.documentChanges else{return}
                    
                    changes.forEach { change in
                        switch change.type{
                        case .removed:
                            let partyId = change.document.documentID
                            
                            withAnimation {
                                self.parties = self.parties.filter { party in
                                    party.id != partyId
                                }
                            }
                        case .added:
                            print("Added")
                        case .modified:
                            print("Modified")
                        }
                    }
                }
            }
        }
    }
    
    func removeData(uuid:String){
        
        guard let party = parties.first(where: {$0.id == uuid}) else{return}
        
        self.removeUserData(party: party)
        
        
        db.collection("Party").document(uuid).delete { error in
            if error == nil{
                print("success remove data")
            }
        }
    }
    
    func removeUserData(party:party){
        party.members.forEach { userId in
            db.collection("User").document(userId).updateData(["party":FieldValue.arrayRemove([party.id])])
        }

    }
}
