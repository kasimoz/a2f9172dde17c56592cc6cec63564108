//
//  CreateSpaceshipView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import SwiftUI

struct CreateSpaceshipView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var createSpaceshipViewModel = CreateSpaceshipViewModel()
    @State private var spaceshipName: String = ""
    @State private var sharedValue: Int = 15
    @State private var showingAlert = false
    @State private var properties = [
        Property(type: .durability, name: Constants.PropertyList.durability, color: Colors.yellow),
        Property(type: .speed, name: Constants.PropertyList.speed, color: Colors.lightPurple),
        Property(type: .capacity, name: Constants.PropertyList.capacity, color: Colors.lightBlue)
    ]
    
    var body: some View {
        ZStack {
            if createSpaceshipViewModel.isExistSpaceship{
                MainView(createSpaceshipViewModel: self.createSpaceshipViewModel)
                    .environment(\.managedObjectContext, viewContext)
            }else{
                VStack(alignment: .center){
                    /// value to be shared
                    TitleView(sharedValue : $sharedValue)
                    /// spaceship name
                    NameView(spaceshipName: $spaceshipName)
                    /// custom slider for properties of spaceship
                    ForEach($properties){ property in
                        CustomSlider(properties: $properties,property:property, sharedValue : $sharedValue)
                    }
                    
                    Spacer()
                    /// continue button
                    HStack(spacing: 10) {
                        Spacer()
                        ForEach(0..<((Int(getRect().width) - 196) / 30), id: \.self){ index in
                            Image(systemName: "airplane")
                                .resizable()
                                .foregroundColor(Colors.lightPurple)
                                .opacity(Double(index + 1) * 0.2)
                                .frame(width: 20, height: 20)
                        }
                        Button {
                            if spaceshipName.isEmpty {
                                showingAlert.toggle()
                            }else if !properties.filter({$0.value == 0}).isEmpty || properties.map({$0.value}).reduce(0, +) != 15 {
                                showingAlert.toggle()
                            }else{
                                self.createSpaceshipViewModel.addSpaceship(spaceshipName: self.spaceshipName, properties: self.properties)
                            }
                        } label: {
                            Text(Constants.CreateSpaceShip.continuee)
                                .font(Font.Atures(.bold, size: 18))
                                .padding(20)
                                .background(Colors.lightPurple)
                                .foregroundColor(Colors.purple)
                                .clipShape(Capsule())
                        }.alert(
                            spaceshipName.isEmpty ? Constants.CreateSpaceShip.emptySpaceshipName:
                                Constants.CreateSpaceShip.totalPointsNotCorrect,
                            isPresented: $showingAlert) {
                                Button(Constants.CreateSpaceShip.ok, role: .cancel) { }
                            }
                            .frame(width: 132)
                            .padding(4)
                    }
                    .background(.black.opacity(0.25))
                    .clipShape(Capsule())
                    .padding(32)
                }
            }
        }.onAppear(){
            self.createSpaceshipViewModel.setup(self.viewContext)
            self.createSpaceshipViewModel.fetchSpaceship()
        }.background(Colors.darkPurple.ignoresSafeArea())
            .overlay(
                ZStack{
                    if createSpaceshipViewModel.success {
                        MainView(createSpaceshipViewModel: self.createSpaceshipViewModel)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
            )
    }
}

struct CreateSpaceshipView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSpaceshipView()
    }
}

struct TitleView: View {
    @Binding var sharedValue: Int
    var body: some View {
        VStack{
            Text(Constants.CreateSpaceShip.description)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.purple)
                .padding()
            Line()
                .stroke(Color.purple, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter , dash: [10]))
                .frame(height: 1)
                .padding(.horizontal)
            HStack{
                Text(Constants.CreateSpaceShip.pointsShared)
                    .font(Font.Atures(.bold, size: 18))
                    .foregroundColor(Colors.purple)
                    .padding()
                Spacer()
                Text("\(sharedValue)")
                    .font(Font.Atures(.black, size: 18))
                    .foregroundColor(Colors.purple).padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Colors.yellow)
        )
        .padding(.horizontal)
    }
}

struct NameView : View {
    @Binding var spaceshipName: String
    var body: some View {
        HStack (spacing : 10){
            Image(systemName: "airplane.circle")
                .foregroundColor(Colors.lightPurple)
            TextField("", text: $spaceshipName)
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.darkPurple)
                .placeHolder(
                    Text(Constants.CreateSpaceShip.spaceshipName)
                        .font(Font.Atures(.regular, size: 14))
                        .foregroundColor(Colors.lightPurple)
                    , show: spaceshipName.isEmpty)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Colors.orange, radius: 2)
        .padding()
    }
}

struct CustomSlider: View {
    @Binding var properties : [Property]
    @Binding var property : Property
    @Binding var sharedValue: Int
    var body: some View {
        VStack{
            HStack {
                Text(property.name)
                    .font(Font.Atures(.bold, size: 14))
                    .foregroundColor(Colors.orange)
                Spacer()
                Text("\(property.value)")
                    .font(Font.Atures(.black, size: 14))
                    .foregroundColor(Colors.orange).padding()
            }
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(height: 20)
                Capsule()
                    .fill(property.color)
                    .frame(width : property.offset + 16, height: 20)
                Circle()
                    .fill(Colors.yellow)
                    .frame(width: 24, height: 24)
                    .background(Circle().stroke(.white, lineWidth: 6))
                    .offset(x: property.offset)
                    .gesture(DragGesture().onChanged({ value in
                        if value.location.x >= 12 && value.location.x <= getRect().width - 44 {
                            let result = calculate(offset: value.location.x - 12)
                            property.offset = CGFloat(result)
                            switch property.type {
                            case .capacity:
                                let f1 = (properties[2].offset + properties[0].offset)
                                let f2 = properties[1].offset
                                if  f1 + f2  > getRect().width - 44 {
                                    property.offset = CGFloat(calculate(offset: getRect().width - 44 - (properties[0].offset + properties[1].offset)))
                                }
                                break
                            case .durability:
                                let f1 = (properties[0].offset + properties[1].offset)
                                let f2 = properties[2].offset
                                if  f1 + f2  > getRect().width - 44 {
                                    property.offset = CGFloat(calculate(offset: getRect().width - 44 - (properties[1].offset + properties[2].offset)))
                                }
                                break
                            case .speed:
                                let f1 = (properties[1].offset + properties[0].offset)
                                let f2 = properties[2].offset
                                if  f1 + f2  > getRect().width - 44 {
                                    property.offset = CGFloat(calculate(offset: getRect().width - 44 - (properties[0].offset + properties[2].offset)))
                                }
                                break
                            }
                            if let index = index(offset: Int(property.offset)) {
                                property.value = index
                                sharedValue = 15 - properties.map({$0.value}).reduce(0, +)
                            }
                        }
                        
                    }))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }
    
    func calculate(offset : CGFloat) -> Int{
        let array: Array<Int> = Array(0...Int(getRect().width - 44)).filter({$0 % Int((getRect().width - 32) / 15) == 0 })
        return array.reduce(100, { x, y in
            abs(Double(x) - offset) > abs(Double(y) - offset) ? y : x
        })
    }
    
    func index(offset : Int) -> Int?{
        let array: Array<Int> = Array(0...Int(getRect().width - 44)).filter({$0 % Int((getRect().width - 32) / 15) == 0 })
        return array.firstIndex(of: offset)
    }
}
