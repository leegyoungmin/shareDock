//
//  HomeView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import SwiftUI

struct HomeView:View{
    let grid = Array(repeating: GridItem(.flexible()), count: 2)
    @State var isPresent:Bool = false
    var body: some View{
        ZStack{
            VStack{
                LazyVGrid(columns: grid){
                    ForEach(1..<5,id:\.self){_ in
                        Text("Example")
                    }
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
        .sheet(isPresented: $isPresent) {
            PartyCreateView()
        }

    }
}

struct HomeView_Previews:PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}
