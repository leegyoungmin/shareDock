//
//  CreateSelfView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/18.
//

import SwiftUI
import Firebase

struct CreateSelfView: View {
    @StateObject var viewModel:CreateViewModel = CreateViewModel()
    @State var selectedUserCount:Int = 1
    @State var selectedDate:Date = Date()
    
    @State var inputTitle:String = ""
    @State var inputFee:Int = 0
    
    private func personRate(_ price:Int)->NSNumber{
        return NSNumber(value: price/self.selectedUserCount)
    }
    
    var body: some View {
        VStack{
            TextField("서비스명을 입력해주세요.", text: $inputTitle)
                .textFieldStyle(signUpTextFieldStyle(title: "서비스명"))
                .padding(.horizontal)
                .padding(.bottom,20)
            
            DatePicker(selection: $selectedDate, displayedComponents: .date) {
                Text("결제일")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .datePickerStyle(.compact)
            .padding(.bottom,10)
            .overlay(
                Rectangle()
                    .frame(height:2)
                ,alignment: .bottom
            )
            .padding(.horizontal)
            .padding(.bottom,20)
            

            
            
            TextField("", value: $inputFee,formatter:currencyFormatter)
                .textFieldStyle(inputTextFieldStyle(title: "요금제", unit: "원"))
                .keyboardType(.numberPad)
                .padding(.bottom,10)
                .overlay(
                    Rectangle()
                        .frame(height:2)
                    ,alignment: .bottom
                )
                .padding(.horizontal)
                .padding(.bottom,20)
            
            HStack{
                Text("인원추가")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text("총원 \(selectedUserCount)명")
            }
            .padding(.bottom,10)
            .overlay(
                Rectangle()
                    .frame(height:2)
                ,alignment: .bottom
            )
            .padding(.horizontal)
            
            
            if viewModel.friends.isEmpty{
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Text("추가된 친구가 없습니다.")
                        Spacer()
                    }
                    .foregroundColor(.indigo)
                    
                    Spacer()
                }
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            }else{
                ScrollView(.vertical, showsIndicators: false) {
                    
                    ForEach(viewModel.friends.indices,id:\.self){ index in
                        memberCellView(selectedCount: $selectedUserCount,
                                       friend: viewModel.friends[index])
                        .environmentObject(self.viewModel)
                        .padding()
                    }
                    
                }
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            }
            
            
            
            Spacer()
            
            HStack(alignment:.center){
                VStack(alignment:.leading,spacing:5){
                    HStack(alignment:.center){
                        Text(currencyString(NSNumber(value: inputFee)))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                        
                        Text("총 \(selectedUserCount)명")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    Text("1인당 금액 : \(currencyString(personRate(inputFee)))")
                }
                
                Spacer()
                
                Button {
                    
                    guard let userId = Firebase.Auth.auth().currentUser?.uid else{return}
                    var members = viewModel.friendIdList
                    members.append(userId)
                    
                    let party = party(
                        name:inputTitle,
                        payer: userId,
                        members: members,
                        platFormIndex: -1,
                        priceName: "",
                        price: inputFee,
                        personPrice: Int(truncating: personRate(inputFee)),
                        payDay: paymentDay(selectedDate) ?? 0
                    )
                    
                    viewModel.createParty(party: party)
                    print(party)
                    
                } label: {
                    HStack{
                        Text("완료")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                        
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
                
            }
            .padding()
            .background(.gray.opacity(0.1))
            .navigationTitle("직접 생성하기")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                UIApplication.shared.endEdit()
            }
        }
    }
}

struct CreateSelfView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSelfView()
    }
}
