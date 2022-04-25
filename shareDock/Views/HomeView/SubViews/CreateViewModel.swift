//
//  CreateViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct party:Codable,Hashable,Identifiable{
    var id = UUID().uuidString
    let name:String?
    let payer:String
    let members:[String]
    let platFormIndex:Int
    let priceName:String
    let price:Int
    let personPrice:Int
    let payDay:Int
}

class CreateViewModel:ObservableObject{
    @Published var friends:[Friend] = []
    var friendIdList:[String] = []
    @Published var selectedFriend:[Friend] = []
    let db = Firestore.firestore()
    
    
    init(){
        fetchFriendIds()
    }
    
    func fetchFriendIds(){
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        
        db.collection("User").document(userId).getDocument { snapshot, error in
            guard let snapshot = snapshot,
                  let friends = snapshot.get("friend") as? [String] else{return}
            
            self.friendIdList = friends
            
            self.fetchFriend()
        }
    }
    
    func fetchFriend(){
        friendIdList.forEach { userId in
            db.collection("User").document(userId).getDocument { snapshot, error in
                guard let snapshot = snapshot else{return}
                do{
                    let user = try snapshot.data(as: Friend.self)
                    
                    self.friends.append(user)
                } catch {
                    print("Error in user \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createParty(party:party){
        guard let values = party.toDic else{return}
        db.collection("Party").document(party.id).setData(values) { error in
            self.updateUserParty(party.id)
        }
    }
    
    func updateUserParty(_ partyId:String){
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        self.friendIdList.append(userId)
        self.friendIdList.forEach { userId in
            db.collection("User").document(userId).updateData(["party":FieldValue.arrayUnion([partyId])])
        }
    }
}
