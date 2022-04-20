//
//  Model + FriendAddViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/15.
//

import Foundation
import Firebase

struct Friend:Hashable,Codable{
    let userId:String
    let userName:String
    let userEmail:String
    let userPhone:String
    
    enum CodingKeys:String, CodingKey{
        case userId
        case userName = "name"
        case userEmail = "email"
        case userPhone = "phone"
    }
}

class FriendAddViewModel:ObservableObject{
    @Published var findPhone:String = ""
    @Published var currentUser:Friend = Friend(userId: "", userName: "", userEmail: "", userPhone: "")
    @Published var findedUser:Friend?
    let reference = Firebase.Database.database().reference()
    
    init(){
        findCurrentUser()
    }
    
    func findUser(){
        Firestore.firestore().collection("User").getDocuments { snapshot, error in
            guard let snapshot = snapshot else{return}
            snapshot.documentChanges.forEach{ change in
                guard let phoneNumber = change.document.get("phone") as? String else{return}
                
                if ("0"+self.findPhone) == phoneNumber{
                    do{
                        let user = try change.document.data(as: Friend.self)
                        self.findedUser = user
                    } catch {
                        print("Error in Find User ::: \(error.localizedDescription)")
                    }
                    
                    return
                }
            }
        }
    }
    
    func findCurrentUser(){
        guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
        
        Firestore.firestore().collection("User")
            .document(userId)
            .getDocument(as: Friend.self) { result in
                switch result{
                case .success(let friend):
                    self.currentUser = friend
                case .failure(let error):
                    print("Error ::: \(error.localizedDescription)")
                }
            }
    }
    
    func addFriend(){
        guard let currentUID = Firebase.Auth.auth().currentUser?.uid,
              let userId = findedUser?.userId else{return}
        
        let db = Firestore.firestore().collection("User")
        
        DispatchQueue.main.async {
            db.document(currentUID).updateData(["friend":FieldValue.arrayUnion([userId])])
            db.document(userId).updateData(["recommend":FieldValue.arrayUnion([currentUID])])
        }
    }
}
