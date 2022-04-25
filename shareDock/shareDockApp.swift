//
//  shareDockApp.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct shareDockApp: App {
    @StateObject var viewModel:SignInViewModel
    init(){
        FirebaseApp.configure()
        _viewModel = StateObject.init(wrappedValue: SignInViewModel())
    }

    
    var body: some Scene {
        WindowGroup {
            if FirebaseAuth.Auth.auth().currentUser != nil{
                ContentView()
                    .environmentObject(self.viewModel)
            }else{
                LoginView()
                    .environmentObject(self.viewModel)
            }
        }
    }
}
