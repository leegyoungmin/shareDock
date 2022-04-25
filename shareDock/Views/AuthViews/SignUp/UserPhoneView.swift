//
//  SignUpViews.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import SwiftUI
import iPhoneNumberField

struct UserPhoneView:View{
    @Binding var isPresent:Bool
    @StateObject var signUpViewModel = SignUpViewModel()
    @State private var isEditing:Bool = false
    @State private var userPhone:String = ""
    @State private var isNumberWrong:Bool = false
    @State private var isPresentNext:Bool = false
    var body: some View{
        
        NavigationView {
            VStack(alignment:.leading){
                HStack{
                    Text("나의 \n핸드폰번호는?")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                    Spacer()
                }
                
                iPhoneNumberField("예) 10-0000-0000", text: $userPhone, isEditing: $isEditing)
                    .numberPlaceholderColor(.indigo)
                    .flagHidden(false)
                    .flagSelectable(false)
                    .font(.preferredFont(forTextStyle: .title2))
                    .maximumDigits(10)
                    .clearButtonMode(.whileEditing)
                    .onClear { _ in
                        isEditing.toggle()
                    }
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("핸드폰 번호를 정확하게 작성해주세요.")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .opacity(isNumberWrong ? 1:0)
                    .padding(.leading,5)
                
                Spacer()
                
                NavigationLink(isActive: $isPresentNext) {
                    UserNameView(isPresent: $isPresent)
                        .environmentObject(self.signUpViewModel)
                } label: {
                    EmptyView()
                }
                
                Button {
                    print("self userphone ::: \(self.userPhone.count)")
                    if userPhone.count == 12{
                        self.isNumberWrong = false
                        self.signUpViewModel.userPhoneNumber = "0"+self.userPhone
                        self.isPresentNext = true
                    }else{
                        self.isNumberWrong = true
                        self.isPresentNext = false
                    }
                } label: {
                    Text("다음으로")
                }
                .buttonStyle(roundedButtonStyle(textColor: .white, color: .indigo))

            }
            .onTapGesture {
                isEditing = false
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
}

struct SignUpView_previews:PreviewProvider{
    static var previews: some View{
        UserPhoneView(isPresent:.constant(true))
    }
}
