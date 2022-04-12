//
//  ContentView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("홈", systemImage: "house")
                    }
                    .navigationTitle("홈")
                
                CreateView()
                    .tabItem {
                        Label("파티생성", systemImage: "person.badge.plus")
                    }
                    .navigationTitle("파티 생성")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
