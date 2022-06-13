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
                    .background(Colors.sliderColor)
                    .clipShape(Capsule())
                    .padding(32)
                }
            }
        }.onAppear(){
            self.createSpaceshipViewModel.setup(self.viewContext)
            self.createSpaceshipViewModel.fetchSpaceship()
        }.background(Colors.backgroundColor.ignoresSafeArea())
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
