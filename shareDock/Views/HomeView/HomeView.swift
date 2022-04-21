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
    @State var isPresent:Bool = false
    @State var selectedParty:party?
    @State var isLongPress:Bool = false
    
    var body: some View{
        ZStack{
            
            List {
                ForEach(viewModel.parties) { party in
                    HomeCellView(party: party)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            self.selectedParty = party
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
//                                viewModel.removeData(party.)
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                        }
                }
            }
            .listStyle(.plain)
            
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
        .sheet(isPresented: $isPresent) {
            PartyCreateView(sheetPresent: $isPresent)
        }
        .sheet(item: $selectedParty, content: { party in
            DetailView(party: party,viewModel: DetailViewModel(userIds: party.members))
        })
        
    }
}

struct HomeCellView:View{
    let party:party
    let plarform:platForm
    
    init(party:party){
        self.party = party
        self.plarform = platforms[party.platFormIndex]
    }
    
    var body: some View{
        HStack{
            VStack(alignment:.leading,spacing:10){
                
                Text(plarform.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(dateComponent(day:party.payDay) + " 결제 예정")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                HStack{
                    Text("총 \(self.party.members.count)명")
                        .font(.callout)
                        .fontWeight(.semibold)
//
                    Text("\(party.personPrice)원씩")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                
            }
            
            Spacer()
            
            Image(plarform.image)
                .resizable()
                .scaledToFit()
                .frame(width:100)
        }
        .font(.title3)
        .foregroundColor(myColor(plarform.logoColor))
        .padding()
        .background(myColor(plarform.backgroundColor))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}
