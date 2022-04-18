//
//  PartyCreateView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/15.
//

import SwiftUI

struct PartyCreateView: View {
    @Binding var sheetPresent:Bool
    let grid = Array(repeating: GridItem(.flexible(),spacing: 20), count: 2)
    @StateObject var viewModel:partyViewModel = partyViewModel()
    @State var isPresent:Bool = false
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: grid,spacing: 20) {
                    
                    ForEach(viewModel.platForms,id:\.self) { platform in
                        
                        NavigationLink {
                            PlatformPartyView(sheetPresent: $sheetPresent, platform: platform)
                        } label: {
                            PartyCellView(data: platform)

                        }
                    }
                    
                    NavigationLink {
                        CreateSelfView()
                    } label: {
                        VStack(alignment:.leading){
                            Text("직접생성")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack{
                                Spacer()
                                
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                
                                Spacer()
                            }
                            .frame(height:100)
                            
                        }
                        .padding()
                        .frame(width:UIScreen.main.bounds.width*0.45)
                        .background(.white)
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 5)
                    }

                    
                }
                .padding()
            }
            .navigationTitle("파티 생성")
        }
    }
}

struct PartyCellView:View{
    let data:platForm
    var body: some View{
        VStack(alignment:.leading){
            Text(data.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(myColor(data.logoColor))
            HStack{
                Spacer()
                
                Image(data.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:100,height:100)
                
                Spacer()
            }
        }
        .padding()
        .frame(width:UIScreen.main.bounds.width*0.45)
        .background(myColor(data.backgroundColor))
        .cornerRadius(20)
        .shadow(color: .gray, radius: 2)
    }
}

struct PartyCreateView_Previews: PreviewProvider {
    @State static var platforms:[platForm] = Bundle.main.decode("platforms.json")
    static var previews: some View {
//        PartyCellView(data: platforms[0])
        PartyCreateView(sheetPresent: .constant(true))
    }
}
