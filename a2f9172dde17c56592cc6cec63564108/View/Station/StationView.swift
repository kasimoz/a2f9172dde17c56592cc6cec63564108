//
//  StationView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

enum ShowView{
    case travelStation
    case missionCompleted
    case missionFailed(message: String)
    case empty
}

struct StationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var createSpaceshipViewModel : CreateSpaceshipViewModel
    @StateObject private var stationViewModel = StationViewModel()
    
    @State private var currentIndex: Int = 0
    @State private var showView: ShowView = .empty
    @State private var duration : Double = 0
    @State private var travelStation: SpaceStation? = nil
    
    @State private var timeRemaining = 1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            /// Properties information
            InformationView(ugs:  stationViewModel.spaceship?.capacity ?? Int32(1),
                            eus: stationViewModel.spaceship?.speed ?? Int32(1),
                            ds: stationViewModel.spaceship?.durability ?? Int32(1))
            
            Line()
                .stroke(Colors.gray, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter , dash: [10]))
                .frame(height: 1)
                .padding(.horizontal)
            /// Spaceship information and calculate damage
            SpaceshipView(name: stationViewModel.spaceship?.name ?? "", damage: Int(stationViewModel.spaceship?.damage ?? 0), timeRemaining: $timeRemaining)
                .onReceive(timer) { time in
                    self.timeRemaining += 1
                    if timeRemaining % (Int(stationViewModel.spaceship?.durability ?? 0) / 1000) == 0{
                        stationViewModel.spaceship?.damage -= 10
                        stationViewModel.updateSpaceship(spaceship: stationViewModel.spaceship!)
                    }
                    if stationViewModel.spaceship?.damage ?? 0 <= 0 {
                        self.timer.upstream.connect().cancel()
                        self.showView = .missionFailed(message: Constants.Stations.damageMessage)
                    }else if !stationViewModel.spaceStations.isEmpty && stationViewModel.spaceStations.allDeliveredSuccesfull() {
                        self.timer.upstream.connect().cancel()
                        self.showView = .missionCompleted
                    }
                }
            Line()
                .stroke(Colors.gray, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter , dash: [10]))
                .frame(height: 1)
                .padding(.horizontal)
            
            /// filter stations
            SearchView(searchQuery: $stationViewModel.searchQuery)
            /// slider stations
            SnapCarousel(index: $currentIndex, currentIndex: $stationViewModel.currentIndex, items: stationViewModel.spaceStations) { station in
                CardView(station: station, mainStation: stationViewModel.mainStation)
            }
            .offset(y: 48)
            
            /// current station
            Text(stationViewModel.spaceship?.mainStation ?? "")
                .font(Font.Atures(.black, size: 24))
                .foregroundColor(Colors.gray)
                .frame(maxWidth : .infinity)
            Spacer()
            
        }.onAppear(){
            self.stationViewModel.setup(NetworkManager(), viewContext: self.viewContext)
            self.stationViewModel.fetchSpaceship()
        }.overlay(
            /// travel to other station
            ZStack(alignment: .center){
                switch showView {
                case .travelStation:
                    VStack(alignment: .center){
                        TransportView(showView: $showView, duration: $duration, image: travelStation?.image ?? Constants.Planet.list[1])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.7))
                    .ignoresSafeArea(.all)
                    .onDisappear(){
                        if var travelStation = travelStation {
                            travelStation.stock = travelStation.capacity
                            let need = travelStation.need ?? 0
                            travelStation.need = 0
                            stationViewModel.updateAllViews(travelStation: travelStation, need : need, eus: duration)
                        }
                    }
                case .missionCompleted:
                    VStack(alignment: .center){
                        MissionCompleteView(showView: $showView)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.7))
                    .ignoresSafeArea(.all)
                    .onDisappear(){
                        self.createSpaceshipViewModel.clearAllCoreData()
                    }
                case .missionFailed(let message):
                    VStack(alignment: .center){
                        MissionFailedView(showView: $showView, message: message)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.7))
                    .ignoresSafeArea(.all)
                    .onDisappear(){
                        self.createSpaceshipViewModel.clearAllCoreData()
                    }
                case .empty:
                    EmptyView()
                }
            }
        )
    }
    
    @ViewBuilder
    func CardView(station: SpaceStation, mainStation: SpaceStation?)-> some View{
        VStack(spacing : 10){
            VStack {
                HStack{
                    VStack(alignment: .leading){
                        Text("\(station.capacity ?? 0)/\(station.stock ?? 0)")
                            .font(Font.Atures(.medium, size: 12))
                            .padding(.bottom, 4)
                        Text("\(CGPoint(x: mainStation?.coordinateX ?? 0.0, y:  mainStation?.coordinateY ?? 0.0).distance(to:CGPoint(x: station.coordinateX!, y:  station.coordinateY!)))EUS")
                            .font(Font.Atures(.medium, size: 12))
                    }
                    Spacer()
                    
                    Button {
                        stationViewModel.updateFavoriteStation(spaceStation: station)
                    } label: {
                        Image(systemName: station.isFavorite ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(station.isFavorite ? Colors.yellow : Colors.lightPurple)
                    }
                }.padding()
                
                Text(station.name ?? "")
                    .font(Font.Atures(.medium, size: 24))
                    .padding()
                
                Button {
                    if stationViewModel.spaceStations.calculateRemainingTime(mainStation: self.stationViewModel.mainStation!) > (stationViewModel.spaceship?.speed ?? Int32(1)){
                        self.timer.upstream.connect().cancel()
                        showView = .missionFailed(message : Constants.Stations.eusMessage)
                    }else if stationViewModel.spaceship?.capacity ?? Int32(1) < station.need ?? 1{
                        self.timer.upstream.connect().cancel()
                        showView = .missionFailed(message : Constants.Stations.ugsMessage)
                    }else {
                        travelStation = station
                        duration = Double(CGPoint(x: mainStation?.coordinateX ?? 0.0, y:  mainStation?.coordinateY ?? 0.0).distance(to:CGPoint(x: station.coordinateX!, y:  station.coordinateY!)))
                        showView = .travelStation
                    }
                    
                } label: {
                    Text(Constants.Stations.travel)
                        .font(Font.Atures(.bold, size: 16))
                        .padding(12)
                        .background(station.capacity == station.stock ? Colors.pink.opacity(0.2) : Colors.pink)
                        .foregroundColor(station.capacity == station.stock ? Colors.darkPurple.opacity(0.2) : Colors.darkPurple)
                        .clipShape(Capsule())
                }
                .padding()
                .disabled(station.capacity == station.stock)
            }
            .background(
                ZStack{
                    Rectangle()
                        .fill(Colors.gray)
                    
                    Image(station.image ?? Constants.Planet.list[1])
                        .resizable()
                        .scaledToFit()
                        .offset(x: -45, y: -45)
                        .opacity(0.5)
                }
            )
            .cornerRadius(25)
            .padding(.bottom, 15)
            
        }
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}




