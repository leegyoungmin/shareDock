//
//  DetailView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/20.
//

import SwiftUI

struct DetailView: View {
    let party:party
    
    private func calculateHeight(minHeight:CGFloat,maxHeight:CGFloat,yOffset:CGFloat)->CGFloat{
        if maxHeight + yOffset < minHeight{
            return minHeight
        }else if maxHeight + yOffset > maxHeight{
            return maxHeight + (yOffset*0.5)
        }
        
        return maxHeight + yOffset
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack{
                VStack{
                    Text("Example")
                }
                .padding(.horizontal,20)
                .padding(.top,300)
                
                GeometryReader { proxy in
                    VStack{
                        HStack{
                            Spacer()
                            Image(party.platForm.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 150, alignment: .center)
                            Spacer()
                        }
                        .frame(height:self.calculateHeight(minHeight: 120, maxHeight: 300, yOffset: proxy.frame(in: .global).origin.y))
                    }
                    .background(
                        myColor(party.platForm.backgroundColor)
                    )
                    .offset(y:proxy.frame(in: .global).origin.y < 0 ? abs(proxy.frame(in: .global).origin.y):-proxy.frame(in: .global).origin.y)
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct DetailView_Previews: PreviewProvider {
    static let exampleparty = party(platForm: shareDock.platForm(name: "티빙", image: "Tving", price: ["프리미엄": 13900, "베이직": 7900, "스탠다드": 10900], logoColor: shareDock.idenColor(red: 255.0, green: 255.0, blue: 255.0), backgroundColor: shareDock.idenColor(red: 255.0, green: 21.0, blue: 60.0)), price: 9900, personPrice: 4950, friends: ["HGyRnVuejERvgSZeytKvqW16e0v2": "이용수"], date: 20)
    static var previews: some View {
        DetailView(party: exampleparty)
    }
}
