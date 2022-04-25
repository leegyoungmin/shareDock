//
//  Extensions.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import SwiftUI
import FirebaseAuth

//String

//ERRORS
enum SignInError:LocalizedError{
    case notExistUser
    case wrongEmail
    case wrongPwd
    case emptyPwd
    
    var errorDescription: String?{
        switch self {
        case .notExistUser:
            return "해당 이메일로 가입된 사용자가 없습니다."
        case .wrongEmail:
            return "잘못된 이메일 형식입니다."
        case .wrongPwd:
            return "틀린 비밀번호입니다."
        case .emptyPwd:
            return "비밀번호를 입력해주세요."
        }
    }
}

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

let currencyFormatter:NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    return formatter
}()

func currencyString(_ value:NSNumber)->String{
    let formatter = currencyFormatter
    let result = formatter.string(from: value) ?? ""
    return result + "원"
}

func paymentDay(_ date:Date)->Int?{
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "dd"
    return Int(formatter.string(from: date))
}

func dateComponent(day:Int) -> String{
    let calendar = Calendar.current
    let currentDate = Date()
    let currentComponent = calendar.dateComponents([.month], from: currentDate)
    let component = DateComponents(month: (currentComponent.month ?? 0) + 1,day: day)
    
    let returnDate = calendar.date(from: component) ?? currentDate
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "M월 d일"
    return dateFormatter.string(from: returnDate)
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

struct inputTextFieldStyle:TextFieldStyle{
    let title:String
    let unit:String
    func _body(configuration:TextField<Self._Label>)->some View{
        HStack(alignment:.center){
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            configuration
                .multilineTextAlignment(.center)
                .frame(maxWidth:100)
                .padding(.horizontal)
                .padding(.vertical,8)
                .background(Color.init(uiColor: UIColor.secondarySystemBackground))
                .cornerRadius(10)
            
            Text(unit)
                .font(.footnote)
                
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
            
            TextField("", text: $email)
                .textFieldStyle(inputTextFieldStyle(title: "요금제",unit:"원"))
            
            Text(currencyString(NSNumber(value: 200000)))
            
            Text(dateComponent(day:14))
        }
        .previewLayout(.sizeThatFits)
        .padding()
        
    }
}
