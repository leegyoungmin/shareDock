//
//  User+SignUpViewModel.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import Firebase

struct User{
    let userName:String
    let userEmail:String
    let userPhone:String
}

class SignUpViewModel:ObservableObject{
    @Published var userPhoneNumber:String = ""
    @Published var userName:String = ""
    @Published var userEmail:String = ""
    @Published var userPassWord:String = ""
    @Published var confirmPassWord:String = ""
    
    func SignUp(completions:@escaping(String?)->Void){
        if userPassWord == confirmPassWord{
            Auth.auth().createUser(withEmail: userEmail, password: userPassWord) { [weak self] result, error in
                guard let self = self else{return}
                
                if error == nil{
                    let data:[String:Any] = [
                        "name":self.userName,
                        "email":self.userEmail,
                        "phone":self.userPhoneNumber
                    ]
                    
                    print("Data ::: \(data)")
                    
                    Database.database().reference()
                        .child("User")
                        .child(result!.user.uid)
                        .setValue(data) { error, _ in
                            guard let error = error else {
                                completions(nil)
                                return
                            }
                            completions(nil)
                        }
                }else{
                    
                    if let errorCode = AuthErrorCode(rawValue: error!._code){
                        print("Error code ::: \(errorCode)")
                        
                        switch errorCode.rawValue{
                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                            completions("이미 가입된 이메일 입니다.")
                        case AuthErrorCode.invalidEmail.rawValue:
                            completions("올바르지 않은 이메일 형식입니다.")
                        case AuthErrorCode.weakPassword.rawValue:
                            completions("안정성이 낮은 비밀번호 입니다.")
                        default:
                            completions(nil)
                        }
                        
                        
                    }
                }
            }
        }else{
            completions("사용자 비밀번호가 일치하지 않습니다.")
        }
    }
}
