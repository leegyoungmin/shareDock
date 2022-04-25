//
//  UserNameView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/13.
//

import SwiftUI

struct UserNameView: View {
    @Binding var isPresent:Bool
    @EnvironmentObject var viewModel:SignUpViewModel
    @State var isPresentNext:Bool = false
    @State var userName:String = ""
    var body: some View {
        VStack{
            HStack{
                Text("나의 \n이름은?")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                Spacer()
            }
            
            TextField("예) 홍길동", text: $userName)
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
            
            Spacer()
            
            NavigationLink(isActive: $isPresentNext) {
                
                UserEmailView(isPresent: $isPresent)
                    .environmentObject(self.viewModel)
            } label: {
                EmptyView()
            }
            
            Button {
                
                self.viewModel.userName = self.userName
                self.isPresentNext = true
            } label: {
                Text("다음으로")
            }
            .buttonStyle(roundedButtonStyle(textColor: .white, color: .indigo))
            
        }
        .onTapGesture {
            UIApplication.shared.endEdit()
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

struct UserNameView_Previews: PreviewProvider {
    static var previews: some View {
        UserNameView(isPresent: .constant(true))
    }
}
