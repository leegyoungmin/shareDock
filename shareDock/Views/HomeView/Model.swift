//
//  Model.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/16.
//

import Foundation


struct platForm:Codable,Hashable{
    let name:String
    var image:String
    let price:[String:Int]
    let logoColor:idenColor
    let backgroundColor:idenColor
    
    enum CodingKeys:String,CodingKey{
        case name,price,image
        case logoColor = "LogoColor"
        case backgroundColor
    }
}

struct idenColor: Codable,Hashable {
    let red, green, blue: Double
}

class partyViewModel:ObservableObject{
    let platForms:[platForm] = Bundle.main.decode("platforms.json")
    
    init(){
        print(platForms)
    }
}
