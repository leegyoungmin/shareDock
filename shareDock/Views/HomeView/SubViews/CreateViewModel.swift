//
//  CreateViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct party:Codable,Hashable{
    let platForm:platForm
    let price:Int
    let personPrice:Int
    let friends:[String:String]
    let date:Int
    let createDay = Date()
    
    enum CodingKeys:String,CodingKey{
        case platForm
        case price
        case personPrice
        case friends
        case date
        case createDay
    }
}

class CreateViewModel:ObservableObject{
    @Published var friends:[Friend] = []
    @Published var selectedFriend:[Friend] = []
    let db = Firestore.firestore()
    
    init(){
        Friends()
    }
    
    func Friends(){
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        
        Firebase.Database.database()
            .reference()
            .child("User")
            .child(userId)
            .child("friend")
            .observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children{
                    let childSnap = child as! DataSnapshot
                    guard let name = childSnap.value as? String else{return}
                    self.friends.append(Friend(userId: childSnap.key, userName: name, userEmail: "", userPhone: ""))
                }
                
            }
    }
    
    func insertSelectedUser(_ value:Friend){
        if !self.selectedFriend.contains(value){
            self.selectedFriend.append(value)
            
        }
    }
    
    func popSelectedUser(_ value:Friend){
        guard let firstIndex = self.selectedFriend.firstIndex(where: {$0.userName == value.userName}) else{return}
        
        self.selectedFriend.remove(at: firstIndex)
    }
    
    func saveData(party:party,completion:@escaping(Bool)->Void){     
        do{
            let uuid = UUID().uuidString
            try db.collection(uuid).document(uuid).setData(from: party)
            realTimeSetData(uuid, name: party.platForm.name)
            completion(true)
        } catch{
            print("Error in set Data \(error.localizedDescription)")
            completion(false)
        }

    }
    
    func realTimeSetData(_ uuid:String,name:String){
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        self.selectedFriend.append(Friend(userId: userId, userName: "", userEmail: "", userPhone: ""))
        self.selectedFriend.forEach{
            Firebase.Database.database().reference()
                .child("User")
                .child($0.userId)
                .child("Party")
                .updateChildValues([name:uuid])
        }
    }
    
    func memberList()->[String:String]{
        var data:[String:String] = [:]
        
        self.selectedFriend.forEach{
            data[$0.userId] = $0.userName
        }
        
        return data
    }
}
