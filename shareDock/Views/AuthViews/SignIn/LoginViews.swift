//
//  LoginViews.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import Firebase
import SwiftUI
import PopupView

struct LoginView:View{
    @EnvironmentObject var viewModel:SignInViewModel
    @State var isShowError:Bool = false
    @State var errorMessage:String = ""
    @State var isPresentSignUp:Bool = false
    var body: some View{
        VStack{
            Image("Logo")
                .resizable()
                .frame(width: 250, height: 250, alignment: .center)
            
            
            TextField("이메일을 입력하세요.", text: $viewModel.userEmail)
                .padding()
                .background(.gray.opacity(0.3))
                .cornerRadius(10)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            SecureField("비밀번호를 입력하세요.", text: $viewModel.userPassWord)
                .padding()
                .background(.gray.opacity(0.3))
                .cornerRadius(10)
            
            Button {
                UIApplication.shared.endEdit()
                self.viewModel.signIn { error in
                    do{
                        try viewModel.throwErrors(error: error)
                    } catch {
                        print("Error in Login ::: \(error.localizedDescription)")
                        self.errorMessage = error.localizedDescription
                        self.isShowError = true
                    }
                }
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
            .cornerRadius(10)
            .disabled(isShowError)
            
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
        .popup(isPresented: $isShowError,autohideIn: 1) {
            ErrorAlertView(message: self.errorMessage)
        }
    }
}

struct ErrorAlertView:View{
    let message:String
    var body: some View{
        VStack{
            Spacer()
            
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(Color.red)
            Spacer()
            
            Text(message)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width*0.8,
               height: UIScreen.main.bounds.width*0.8)
        .background(Color.init(red: 105, green: 105, blue: 105))
        .cornerRadius(20)
        .shadow(color: .gray, radius: 12)
        
        
    }
}

struct LoginView_Previews:PreviewProvider{
    static var previews: some View{
        ErrorAlertView(message: "잘못된 이메일 형식입니다.")
            .previewLayout(.sizeThatFits)
    }
}

