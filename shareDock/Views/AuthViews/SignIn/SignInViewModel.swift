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
    
    func signIn(completion:@escaping(Error)->Void){
        Auth.auth().signIn(withEmail: userEmail, password: userPassWord) {[weak self] result, error in
            guard let self = self else{return}
            if error == nil{
                withAnimation {
                    self.isLogged = true
                }

            }else{
                completion(error!)
            }
        }
    }
    
    func throwErrors(error:Error) throws{
        guard let error = error as? NSError,
              let errorCode = FirebaseAuth.AuthErrorCode(rawValue: error.code) else{return}
        
        
        switch errorCode{
        case .userNotFound:
            throw SignInError.notExistUser
        case .invalidEmail:
            throw SignInError.wrongEmail
        case .wrongPassword:
            
            if self.userPassWord.isEmpty{
                throw SignInError.emptyPwd
            }else{
                throw SignInError.wrongPwd
            }
            
        default: print(error.code)
        }
    }
}
