//
//  ContentView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var LoginViewModel:SignInViewModel
    @State var selection:Int = 0
    @State var isPresentPlus:Bool = false
    
    private func convertTitle()->String{
        var title:String = "홈"
        if selection == 0{
            title = "홈"
        }
        else if selection == 1{
            title = "친구목록"
        }
        return title
    }
    
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Label("홈", systemImage: "house")
                    }
                
                FriendsView()
                    .tag(1)
                    .tabItem {
                        Label("친구 목록", systemImage: "person.2")
                    }

            }
            .navigationTitle(convertTitle())
            .fullScreenCover(isPresented: $isPresentPlus, content: {
                FriendAddView(isPresent: $isPresentPlus)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu {
                        Button {
                            do{
                                try Firebase.Auth.auth().signOut()
                                self.LoginViewModel.userEmail = ""
                                self.LoginViewModel.userPassWord = ""
                                self.LoginViewModel.isLogged = false
                            } catch{
                                print(error.localizedDescription)
                            }

                        } label: {
                            Text("로그 아웃")
                        }
                        
                        Button {
                            self.isPresentPlus = true
                        } label: {
                            Text("친구 추가")
                        }


                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
