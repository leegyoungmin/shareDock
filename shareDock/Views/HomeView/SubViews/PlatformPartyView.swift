//
//  PlatformPartyView.swift
//  shareDock
//
//  Created by 이경민 on 2022/04/18.
//

import SwiftUI

struct PlatformPartyView: View {
    @Binding var sheetPresent:Bool
    let platform:platForm
    @State var selectedKey:String = ""
    @State var selectedUserCount:Int = 1
    @State var selectedDate = Date()
    @StateObject var viewModel:CreateViewModel = CreateViewModel()
    
    private func personRate(_ price:Int)->NSNumber{
        return NSNumber(value: price/self.selectedUserCount)
    }
    
    var body: some View {
        VStack{
            
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
                    .frame(height:1)
                ,alignment: .bottom
            )
            .padding(.horizontal)
            .padding(.bottom,20)
            
            HStack{
                Text("요금제")
                    .font(.title3)
                    .fontWeight(.semibold)

                Spacer()
                
                Picker("", selection: $selectedKey) {
                    ForEach(platform.price.sorted(by: <),id:\.key) { key,value in
                        Text("\(key)")
                            .fontWeight(.semibold)
                            .onTapGesture {
                                withAnimation {
                                    selectedKey = key
                                }

                            }
                    }
                }
                .pickerStyle(.menu)
                
            }
            .padding(.bottom,10)
            .overlay(
                Rectangle()
                    .frame(height:1)
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
                    .frame(height:1)
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
                        Text(currencyString(NSNumber(value: platform.price[selectedKey] ?? 0)))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                        
                        Text("총 \(selectedUserCount)명")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    Text("1인당 금액 : \(currencyString(personRate(platform.price[selectedKey] ?? 0)))")
                }
                
                
                Spacer()
                
                Button {
                    
                    let party = party(platForm:platform,
                                      price: platform.price[selectedKey] ?? 0,
                                      personPrice: Int(truncating: personRate(platform.price[selectedKey] ?? 0)),
                                      friends: viewModel.memberList(),
                                      date: paymentDay(selectedDate) ?? 0)
                    viewModel.saveData(party: party) { isSuccess in
                        if isSuccess{
                            self.sheetPresent = false
                        }else{
                            print("Error in Create Data")
                        }
                    }
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
 
            
            
        }
        .navigationTitle(platform.name)
    }
}

struct memberCellView:View{
    @EnvironmentObject var viewModel:CreateViewModel
    @Binding var selectedCount:Int
    @State var isSelctedCell:Bool = false
    let friend:Friend
    var body: some View{
        HStack{
            Text(friend.userName)
            Spacer()
            
            Button {
                
                if isSelctedCell{
                    selectedCount -= 1
                    self.viewModel.popSelectedUser(friend)
                }else{
                    selectedCount += 1
                    self.viewModel.insertSelectedUser(friend)
                }
                
                isSelctedCell.toggle()

            } label: {
                Image(systemName: isSelctedCell ? "checkmark.circle.fill":"circle")
            }

        }
    }
}

struct PlatformPartyView_Previews: PreviewProvider {
    @State static var platforms:[platForm] = Bundle.main.decode("platforms.json")
    static var previews: some View {
        PlatformPartyView(sheetPresent: .constant(true), platform: platforms[0])
    }
}
