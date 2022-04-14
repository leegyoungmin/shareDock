//
//  FriendAddView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/14.
//

import SwiftUI

struct FriendAddView: View {
    @Binding var isPresent:Bool
    var body: some View {
        NavigationView{
            Text("Example")
                .navigationTitle("친구추가")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.isPresent = false
                        } label: {
                            Image(systemName: "xmark")
                        }

                    }
                }
        }
        
    }
}

struct FriendAddView_Previews: PreviewProvider {
    static var previews: some View {
        FriendAddView(isPresent: .constant(true))
    }
}
