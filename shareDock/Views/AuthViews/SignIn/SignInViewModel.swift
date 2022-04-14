//
//  SignInViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/14.
//

import Foundation
import Firebase
import SwiftUI

class SignInViewModel:ObservableObject{
    @Published var isLogged:Bool = false
    @Published var userEmail:String = ""
    @Published var userPassWord:String = ""
    
    
    init(){
        self.isLogged = (FirebaseAuth.Auth.auth().currentUser != nil)
    }
    
    func signIn(){
        Auth.auth().signIn(withEmail: userEmail, password: userPassWord) { result, error in
            if error == nil{
                withAnimation {
                    self.isLogged = true
                }

            }else{
                print("Error ::: \(error?.localizedDescription)")
                self.isLogged = false
            }
        }
    }
}
