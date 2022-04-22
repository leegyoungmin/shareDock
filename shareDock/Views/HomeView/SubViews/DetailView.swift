//
//  DetailView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/20.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel:DetailViewModel
    let party:party
    let platForm:platForm
    let grid = [GridItem(.flexible())]
    
    init(party:party,viewModel:DetailViewModel){
        self.party = party
        self.platForm = platforms[party.platFormIndex]
        _viewModel = StateObject.init(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            VStack{
                ZStack{
                    HStack{
                        Spacer()
                        Image(platForm.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 150, alignment: .center)
                        Spacer()
                    }
                    .frame(height:250)
                    .background(myColor(platForm.backgroundColor))

                    HStack{
                        Spacer()

                        VStack{
                            Button {
                                self.dismiss.callAsFunction()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.5))
                                    .font(.title2)
                            }
                            .padding()

                            Spacer()
                        }
                    }

                }



                VStack(alignment:.leading,spacing: 20){
                    
                    
                    VStack (spacing:5){
                        HStack{
                            Text("\(party.priceName)")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("\(currencyString(NSNumber(value: party.personPrice)))")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                        
                        HStack {
                            Text(dateComponent(day:party.payDay))
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .padding(5)
                                .cornerRadius(5)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke()
                                        .foregroundColor(.gray)
                                )
                            
                            Spacer()
                            
                            Text("\(currencyString(NSNumber(value: party.price)))/\(party.members.count)명")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Divider()

                    HStack(alignment:.bottom){
                        Text("친구 목록")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Spacer()
                    }

                    LazyVGrid(columns: grid, alignment: .leading, spacing: 10) {
                        
                        
                        ForEach(viewModel.userNameList.sorted(by: {$0.userName < $1.userName}),id:\.self){ user in
                            friendCellView(user: user)
                                .padding(.horizontal)
                                .padding(.vertical,10)
                        }
                    }

                }
                .padding(.horizontal)
            }

        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarHidden(true)
    }
}

struct friendCellView:View{
    let user:partyUser
    var body: some View{
        HStack{
            Text(user.userName)
            
            Spacer()
            
            if user.payUser{
                Image(systemName: "creditcard.fill")
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let exampleparty = party(payer: "이경민", members: ["ㅁㄴㅇ","asjdn"], platFormIndex: 1, priceName: "베이직", price: 9900, personPrice: 3300, payDay: 15)
    static var previews: some View {
        DetailView(party: exampleparty, viewModel: DetailViewModel(party: exampleparty))
    }
}
