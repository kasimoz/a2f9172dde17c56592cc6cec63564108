//
//  StationView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

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
                .stroke(Colors.darkBlue, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter , dash: [10]))
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
                .stroke(Colors.darkBlue, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter , dash: [10]))
                .frame(height: 1)
                .padding(.horizontal)
            
            /// filter stations
            SearchView(searchQuery: $stationViewModel.searchQuery)
            /// slider stations
            SnapCarousel(index: $currentIndex, items: stationViewModel.spaceStations) { station in
                CardView(station: station, mainStation: stationViewModel.mainStation)
            }
            .offset(y: 48)
            
            /// current station
            Text(stationViewModel.spaceship?.mainStation ?? "")
                .font(Font.Atures(.black, size: 24))
                .foregroundColor(.black)
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
                        TransportView(showView: $showView, duration: $duration)
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
                    
                    Image(station.image ?? "planet1")
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

enum ShowView{
    case travelStation
    case missionCompleted
    case missionFailed(message: String)
    case empty
}

struct InformationView : View{
    var ugs : Int32
    var eus : Int32
    var ds : Int32
    
    var body: some View{
        HStack {
            ZStack {
                Text("\(Constants.Damage.UGS)\n\(ugs)")
                    .font(Font.Atures(.bold, size: 16))
                    .lineSpacing(16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
            }.background(
                Rectangle()
                    .fill(Colors.lightBlue)
                    .cornerRadius(10)
            )
            Spacer()
            ZStack {
                Text("\(Constants.Damage.EUS)\n\(eus)")
                    .font(Font.Atures(.bold, size: 16))
                    .lineSpacing(16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
            }.background(
                Rectangle()
                    .fill(Colors.blue)
                    .cornerRadius(10)
            )
            Spacer()
            ZStack {
                Text("\(Constants.Damage.DS)\n\(ds)")
                    .font(Font.Atures(.bold, size: 16))
                    .lineSpacing(16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
            }.background(
                Rectangle()
                    .fill(Colors.pink)
                    .cornerRadius(10)
            )
        }
        .padding(.horizontal)
    }
}

struct SpaceshipView : View{
    var name : String
    var damage : Int
    @Binding var timeRemaining : Int
    
    var body: some View {
        HStack {
            Text(name)
                .font(Font.Atures(.bold, size: 16))
                .foregroundColor(Colors.darkPurple)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
            Text("\(damage)")
                .font(Font.Atures(.bold, size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(Colors.purple)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
            Text("\(timeRemaining)s")
                .font(Font.Atures(.black, size: 16))
                .multilineTextAlignment(.trailing)
                .foregroundColor(Colors.darkBlue)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                
        }
        .background(
            Rectangle()
                .fill(Colors.yellow)
                .cornerRadius(10)
        )
        .padding(.horizontal)
    }
}


struct SearchView : View {
    @Binding var searchQuery: String
    var body: some View {
        HStack (spacing : 10){
            Image(systemName: "magnifyingglass")
                .foregroundColor(Colors.purple)
            TextField("", text: $searchQuery)
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.darkPurple)
                .placeHolder(
                    Text(Constants.Stations.stationName)
                        .font(Font.Atures(.regular, size: 14))
                        .foregroundColor(Colors.purple)
                    , show: searchQuery.isEmpty)
        }
        .frame(height: 48)
        .padding(.horizontal)
        .background(Color.orange)
        .cornerRadius(24)
        .shadow(color: Colors.pink, radius: 5)
        .padding()
    }
}

struct TransportView: View {
    @State var offset : CGFloat = 0
    @Binding var showView : ShowView
    @Binding var duration : Double
    var body: some View {
        VStack{
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                Line()
                    .stroke(Colors.lightPurple, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .miter , dash: [5]))
                    .frame(height: 1)
                    .padding(.horizontal)
                Image("planet1")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .offset(x: getRect().width - 114)
                Image(systemName: "airplane")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .offset(x: offset)
                    .onAnimationCompleted(for: offset) {
                        showView = .empty
                    }
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 80)
        .padding(.top, 32)
        .animation(.easeInOut(duration: duration).delay(0.5), value: offset)
        .onAppear(){
            offset = getRect().width - 114
        }
    }
}

struct MissionCompleteView: View {
    @Binding var showView : ShowView
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Colors.darkBlue)
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .foregroundColor(Colors.darkBlue)
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Colors.darkBlue)
                Spacer()
            }.padding()
            Text(Constants.Stations.missionCompleted)
                .font(Font.Atures(.black, size: 24))
                .foregroundColor(Colors.darkBlue)
                .padding()
            Button {
                showView = .empty
            } label: {
                Text(Constants.Stations.returnToWorld)
                    .font(Font.Atures(.bold, size: 18))
                    .padding(16)
                    .background(Colors.pink)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            
        }
    }
}

struct MissionFailedView: View {
    @Binding var showView : ShowView
    var message : String
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .trim(from: 0.07, to: 0.43)
                    .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [1]))
                    .frame(width: 158, height: 158)
                    .rotationEffect(.init(degrees: -5))
                
                Circle()
                    .trim(from: 0.07, to: 0.43)
                    .stroke(.red, style: StrokeStyle(lineWidth: 10))
                    .frame(width: 172, height: 172)
                    .rotationEffect(.init(degrees: -5))
                
                Circle()
                    .trim(from: 0.57, to: 0.93)
                    .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [1]))
                    .frame(width: 158, height: 158)
                    .rotationEffect(.init(degrees: -5))
                
                Circle()
                    .trim(from: 0.57, to: 0.93)
                    .stroke(.red, style: StrokeStyle(lineWidth: 10))
                    .frame(width: 172, height: 172)
                    .rotationEffect(.init(degrees: -5))
                
                ForEach(1..<13){index in
                    Star(count: index)
                        .rotationEffect(.init(degrees: -5))
                }
                
                Text(Constants.Stations.missionFailed)
                    .font(Font.Atures(.black, size: 22))
                    .foregroundColor(.white)
                    .padding(16)
                    .background(.red)
                    .clipShape(Rectangle())
                    .cornerRadius(5)
                    .padding(4)
                    .overlay(
                        Rectangle()
                            .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [1]))
                            .cornerRadius(5)
                     )
                    .padding(4)
                    .border(Color.red, width: 3)
                    .cornerRadius(5)
                    .rotationEffect(.init(degrees: -5))
            }
            Text(message)
                .font(Font.Atures(.medium, size: 16))
                .foregroundColor(.red)
                .padding()
            Button {
                showView = .empty
            } label: {
                Text(Constants.Stations.returnToWorld)
                    .font(Font.Atures(.bold, size: 18))
                    .padding(16)
                    .background(Colors.navyBlue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 32)
            
        }
    }
}

struct Star : View {
    var count: Int
    var body: some View{
        VStack{
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor([2,4,8,10].contains(count) ? .clear : .red)
                .rotationEffect(.radians(-(Double.pi*2 / 12 * Double(count))))
            Spacer()
        }
        .padding()
        .rotationEffect(.radians((Double.pi * 2 / 12 * Double(count))))
        .frame(width: 172, height: 172)
    }
}


