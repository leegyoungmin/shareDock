//
//  Extensions.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import SwiftUI

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

extension UIApplication{
    func endEdit(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct roundedButtonStyle:ButtonStyle{
    let textColor:Color
    let color:Color
    func makeBody(configuration: Configuration) -> some View {
        HStack{
            Spacer()
            
            configuration
                .label
                .foregroundColor(textColor)
            
            Spacer()
        }
        .padding(.vertical,10)
        .background( configuration.isPressed ? .gray.opacity(0.2):color)
        .cornerRadius(10)
        
    }
}

struct signUpTextFieldStyle:TextFieldStyle{
    let title:String
    func _body(configuration: TextField<Self._Label>) -> some View {
        
        VStack(alignment: .leading,spacing:20){
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            configuration
                .padding(.bottom)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height:2)
                    ,alignment: .bottom
                )
        }
        
        
    }
}

struct extensions_previews:PreviewProvider{
    @State static var email:String = ""
    static var previews: some View{
        
        Group{
            Button {
                print(123)
            } label: {
                Text("회원가입")
            }
            .buttonStyle(roundedButtonStyle(textColor: .white,color: .indigo))
            
            TextField("example", text: $email)
                .textFieldStyle(signUpTextFieldStyle(title: "이름"))
        }
        .previewLayout(.sizeThatFits)
        .padding()
        
    }
}
