//
//  UserEmailView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/13.
//

import SwiftUI

struct UserEmailView: View {
    @Binding var isPresent:Bool
    @EnvironmentObject var viewModel:SignUpViewModel
    @State private var isPresentNext:Bool = false
    @State private var userEmail:String = ""
    @State private var domainIndex:Int = 0
    @State private var isValidation:Bool = false
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Text("나의 \n이메일은?")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                Spacer()
            }
            
            
            TextField("예) abc123@abc.com", text: $userEmail)
                .textContentType(.emailAddress)
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            Text("이메일을 다시 작성해주세요.")
                .font(.footnote)
                .foregroundColor(.red)
                .opacity(isValidation ? 1:0)
                .padding(.leading,5)

            
            Spacer()
            
            NavigationLink(isActive: $isPresentNext) {
                UserPassWordView(isPresent: $isPresent)
                    .environmentObject(self.viewModel)
            } label: {
                EmptyView()
            }

            Button {
                if isValidEmail(testStr: self.userEmail){
                    self.viewModel.userEmail = self.userEmail
                    self.isPresentNext = true
                }else{
                    self.isPresentNext = false
                    self.isValidation = true
                }
                
            } label: {
                Text("다음으로")
            }
            .buttonStyle(roundedButtonStyle(textColor: .white, color: .accentColor))
        }
        .navigationBarTitleDisplayMode(.large)
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.isPresent = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }

            }
        }
    }
}

struct UserEmailView_Previews: PreviewProvider {
    static var previews: some View {
        UserEmailView(isPresent: .constant(true))
            .environmentObject(SignUpViewModel())
    }
}
