//
//  FriendsView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/14.
//

import SwiftUI

struct FriendsView: View {
    @StateObject var viewModel:FriendViewModel = FriendViewModel()
    var body: some View {
        VStack(alignment: .center){
            if viewModel.friends.isEmpty{
                Text("추가된 친구가 없습니다.\n상단에서 친구를 추가해주세요.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundColor(.indigo)
                    .frame(alignment:.center)

            }else{
                
                List(viewModel.friends,id:\.self){ userName in
                    Text(userName)
                }
                .listStyle(.plain)
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(viewModel: FriendViewModel())
    }
}
