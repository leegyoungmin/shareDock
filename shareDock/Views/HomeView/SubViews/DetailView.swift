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



                VStack(alignment:.leading){
                    
                    GroupBox {
                        VStack{
                            HStack{
                                Text("금액")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(currencyString(NSNumber(value: party.price)))")
                                    
                            }

                            
                            HStack{
                                Text("다음 결제일")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(dateComponent(day:party.payDay))
                                    
                            }
                        }
                    } label: {
                        Text(party.priceName)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        //PERSONPRICE
                        HStack{
                            Text("\(currencyString(NSNumber(value: party.personPrice)))")
                                .font(.system(size: 40))
                                .fontWeight(.black)
                                .foregroundColor(.indigo)

                            Text("× \(party.members.count)명")
                                .font(.title)
                                .fontWeight(.heavy)
                        }
                    }
                    .padding(.vertical)
                    
                    Divider()

                    HStack(alignment:.bottom){
                        Text("친구 목록")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Spacer()
                    }

                    LazyVGrid(columns: grid, alignment: .leading, spacing: 10) {
                        
                        ForEach(viewModel.userNameList.sorted(by: <),id:\.self){ name in
                            HStack{
                                Text(name)
                                Spacer()
                            }
                            .padding()
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

//struct DetailView_Previews: PreviewProvider {
//    static let exampleparty = party(platForm: shareDock.platForm(name: "티빙", image: "Tving", price: ["프리미엄": 13900, "베이직": 7900, "스탠다드": 10900], logoColor: shareDock.idenColor(red: 255.0, green: 255.0, blue: 255.0), backgroundColor: shareDock.idenColor(red: 255.0, green: 21.0, blue: 60.0)),priceName: "프리미엄" ,price: 9900, personPrice: 4950, friends: ["HGyRnVuejERvgSZeytKvqW16e0v2": "이용수"], date: 20)
//    static var previews: some View {
//
//        DetailView(party: exampleparty)
//    }
//}
