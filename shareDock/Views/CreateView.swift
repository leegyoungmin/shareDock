//
//  CreateView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/12.
//

import Foundation
import SwiftUI

struct CreateView:View{
    var body: some View{
        ZStack{
            Text("Example")
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        print(123)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 40))
                    }
                }
            }
            .padding()

        }
    }
}

struct CreateView_previews:PreviewProvider{
    static var previews: some View{
        CreateView()
    }
}
