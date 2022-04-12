//
//  shareDockApp.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import SwiftUI
import Firebase

@main
struct shareDockApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
