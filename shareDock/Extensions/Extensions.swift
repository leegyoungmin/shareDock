//
//  Extensions.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import SwiftUI

//RESOURCE
let platforms:[platForm] = Bundle.main.decode("platforms.json")

//FIREBASE-HELPER
extension Encodable{
    var toDic:[String:Any]?{
        guard let object = try? JSONEncoder().encode(self) else{return nil}
        
        guard let dic = try? JSONSerialization.jsonObject(with: object,options: []) as? [String:Any] else{return nil}
        
        return dic
    }
}

//Colors
func myColor(_ value:idenColor)->Color{
    return Color.init(red: value.red/255, green: value.green/255, blue: value.blue/255)
}

//String
func currencyString(_ value:NSNumber)->String{
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    let result = formatter.string(from: value) ?? ""
    return result + "원"
}

func paymentDay(_ date:Date)->Int?{
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "dd"
    return Int(formatter.string(from: date))
}


//Files
extension Bundle{
    func decode<T:Codable>(_ file:String)->T{
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in Bundle.")
        }
        //2. Create property
        guard let data = try? Data(contentsOf: url) else{
            fatalError("Failed to Load \(file) from Bundle.")
        }
        //3. Create decoder
        let decoder = JSONDecoder()
        
        //4. deocoded data
        guard let loaded = try? decoder.decode(T.self, from: data) else{
            fatalError("Failed to decode \(file) from Bundle.")
        }
        //5. return data
        return loaded
    }
}

func convert(_ value:Double)->Double{
    return value/255
}

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
            
            Text(currencyString(NSNumber(value: 200000)))
        }
        .previewLayout(.sizeThatFits)
        .padding()
        
    }
}
