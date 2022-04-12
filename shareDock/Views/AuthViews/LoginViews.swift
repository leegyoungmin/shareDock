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
    @State var email:String = ""
    @State var passWord:String = ""
    @State var isPresentSignUp:Bool = false
    var body: some View{
        VStack{
            Text("구독가치")
                .font(.largeTitle)
                .frame(minHeight:200)
            
            
            TextField("이메일을 입력하세요.", text: $email)
                .textFieldStyle(.roundedBorder)
            
            SecureField("비밀번호를 입력하세요.", text: $passWord)
                .textFieldStyle(.roundedBorder)
            
            Button {
                print(123)
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
            SignUpView()
        }
    }
}


struct LoginView_previews:PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}
