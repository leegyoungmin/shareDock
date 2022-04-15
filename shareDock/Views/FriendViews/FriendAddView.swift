//
//  FriendAddView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/14.
//

import SwiftUI
import iPhoneNumberField

struct FriendAddView: View {
    @StateObject var viewModel = FriendAddViewModel()
    @Binding var isPresent:Bool
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment:.leading){
                    Text("친구의 번호를 검색하세요.")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack{
                        iPhoneNumberField(text: $viewModel.findPhone)
                            .flagHidden(true)
                            .flagSelectable(false)
                            .maximumDigits(10)
                            .padding(5)
                        
                        Button {
                            viewModel.findUser()
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(20)
                
                if viewModel.findedUser != nil{
                    let user = viewModel.findedUser!
                    VStack{
                        
                        Text(user.userName)
                        Text(user.userEmail)
                        Text(user.userPhone)
                        
                        Button {
                            DispatchQueue.main.async {
                                viewModel.addFriend()
                                viewModel.addRecommend()
                                self.isPresent = false
                            }
                        } label: {
                            Text("친구추가")
                        }
                        .buttonStyle(roundedButtonStyle(textColor: .indigo, color: .white))
                    }
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(20)
                }
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("친구추가")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.isPresent = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        
    }
}

struct FriendAddView_Previews: PreviewProvider {
    static var previews: some View {
        FriendAddView(isPresent: .constant(true))
    }
}
