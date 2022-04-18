//
//  HomeView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import SwiftUI

struct HomeView:View{
    @StateObject var viewModel = HomeViewModel()
    let platforms:[platForm] = Bundle.main.decode("platforms.json")
    let grid = Array(repeating: GridItem(.flexible()), count: 2)
    @State var isPresent:Bool = false
    var body: some View{
        ZStack{
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.parties.sorted(by: {$0.platForm.name<$1.platForm.name}),id:\.self) { party in
                    HomeCellView(party: party)
                        .padding()
                }
            }
            
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    
                    Button {
                        self.isPresent = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                    }

                }
            }
            .padding()
        }
        .sheet(isPresented: $isPresent,onDismiss: {
            viewModel.ObservePartyList {
                viewModel.ObserveData()
            }
        }) {
            PartyCreateView(sheetPresent: $isPresent)
        }

    }
}

struct HomeCellView:View{
    let party:party
    var body: some View{
        HStack{
            VStack(alignment:.leading,spacing:10){
                Text(party.platForm.name)
                Text("\(party.friends.count)명")
            }
            
            Spacer()
            
            Image(party.platForm.image)
                .resizable()
                .scaledToFit()
                .frame(width:100)
        }
        .font(.title3)
        .foregroundColor(myColor(party.platForm.logoColor))
        .padding()
        .background(myColor(party.platForm.backgroundColor))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}

struct HomeView_Previews:PreviewProvider{
    static let exampleparty = party(platForm: platForm(name: "디즈니 플러스", image: "Disney", price: ["베이직": 9900], logoColor: shareDock.idenColor(red: 191.0, green: 245.0, blue: 253.0), backgroundColor: shareDock.idenColor(red: 9.0, green: 11.0, blue: 39.0)), price: 9900, personPrice: 4950, friends: ["HGyRnVuejERvgSZeytKvqW16e0v2": "이용수"], date: 20)
    static var previews: some View{
        HomeCellView(party: exampleparty)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
