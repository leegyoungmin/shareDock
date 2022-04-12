//
//  SignUpViews.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import SwiftUI

struct SignUpView:View{
    @Environment(\.dismiss) private var dismiss
    @StateObject var signUpViewModel = SignUpViewModel()
    var body: some View{
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing:20){
                    
                    TextField("예) 홍길동", text: $signUpViewModel.userName)
                        .textFieldStyle(signUpTextFieldStyle(title: "이름"))
                        .textContentType(.name)

                    TextField("예) abc123@naver.com", text: $signUpViewModel.userEmail)
                        .textFieldStyle(signUpTextFieldStyle(title: "이메일"))
                        .textContentType(.emailAddress)
                    
                    SecureField("", text: $signUpViewModel.userPassWord)
                        .textFieldStyle(signUpTextFieldStyle(title: "비밀번호"))
                        .textContentType(.newPassword)
                    
                    SecureField("", text: $signUpViewModel.confirmPassWord)
                        .textFieldStyle(signUpTextFieldStyle(title: "비밀번호 확인"))
                        .textContentType(.newPassword)
                    
                    Spacer()
                    
                    Button {
                        signUpViewModel.SignUp { message in
                            if message == nil{
                                self.dismiss.callAsFunction()
                            }else{
                                print("Error in sign up ::: \(message!)")
                            }
                        }
                    } label: {
                        Text("생성하기")
                    }
                    .buttonStyle(roundedButtonStyle(textColor: .white, color: .indigo))

                    
                }
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.automatic)
            .padding()
        }
    }
}

struct SignUpView_previews:PreviewProvider{
    static var previews: some View{
        SignUpView()
    }
}
