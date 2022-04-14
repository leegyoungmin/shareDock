//
//  UserPassWordView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/14.
//

import SwiftUI

struct UserPassWordView: View {
    @Binding var isPresent:Bool
    @EnvironmentObject var viewModel:SignUpViewModel
    @State var userPassWord:String = ""
    @State var userConfirmWord:String = ""
    @State var isNotCorrect:Bool = false
    var body: some View {
        VStack{
            HStack{
                Text("비밀번호를 \n생성해주세요.")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(alignment:.leading){
                SecureField("비밀번호를 작성해주세요.", text: $userPassWord)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                
                SecureField("비밀번호를 동일하게 작성해주세요.", text: $userConfirmWord)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("동일한 비밀번호를 작성해주세요.")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .opacity(isNotCorrect ? 1:0)
                
            }
            .padding(.top)
            
            
            Spacer()
            
            Button {
                if self.userPassWord == self.userConfirmWord && (!self.userPassWord.isEmpty && !self.userConfirmWord.isEmpty){
                    self.viewModel.userPassWord = userPassWord
                    self.viewModel.confirmPassWord = userConfirmWord
                    self.viewModel.SignUp { error in
                        if error == nil{
                            self.isPresent = false
                        }else{
                            print(error!)
                        }
                    }
                }else{
                    self.isNotCorrect = true
                }
            } label: {
                Text("가입완료")
            }
            .buttonStyle(roundedButtonStyle(textColor: .white, color: .indigo))
        }
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
}
struct UserPassWordView_Previews: PreviewProvider {
    static var previews: some View {
        UserPassWordView(isPresent: .constant(false))
            .environmentObject(SignUpViewModel())
    }
}
