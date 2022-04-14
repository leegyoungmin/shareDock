//
//  LoginViews.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import Firebase
import SwiftUI

struct LoginView:View{
    @EnvironmentObject var viewModel:SignInViewModel
    @State var isPresentSignUp:Bool = false
    var body: some View{
        VStack{
            Text("구독가치")
                .font(.largeTitle)
                .frame(minHeight:200)
            
            
            TextField("이메일을 입력하세요.", text: $viewModel.userEmail)
                .textFieldStyle(.roundedBorder)
            
            SecureField("비밀번호를 입력하세요.", text: $viewModel.userPassWord)
                .textFieldStyle(.roundedBorder)
            
            Button {
                self.viewModel.signIn()
            } label: {
                HStack{
                    Spacer()
                    
                    Text("로그인하기")
                        .padding(.vertical,10)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .background(.indigo)
            .cornerRadius(5)

            Spacer()
            
            Button {
                isPresentSignUp = true
            } label: {
                Text("회원가입하러 가기")
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isPresentSignUp) {
            UserPhoneView(isPresent: $isPresentSignUp)
        }
    }
}


struct LoginView_previews:PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}
