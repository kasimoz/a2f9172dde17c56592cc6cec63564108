//
//  FavoritesView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            /// Title
            Text(Constants.Tabs.favorites)
                .font(Font.Atures(.black, size: 24))
                .foregroundColor(Colors.darkBlue)
                .frame(maxWidth : .infinity)
            
            Line()
                .stroke(Colors.blue, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter , dash: [10]))
                .frame(height: 1)
                .padding(.horizontal)
            /// List
            List(favoritesViewModel.spaceStations) { station in
                CardView(station: station, mainStation: favoritesViewModel.mainStation)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            Spacer()
            
        }.onAppear(){
            self.favoritesViewModel.setup(viewContext: self.viewContext)
            self.favoritesViewModel.fetchFavoriteStations()
        }
    }
    
    @ViewBuilder
    func CardView(station: SpaceStation, mainStation: SpaceStation?)-> some View{
        VStack(alignment: .leading, spacing: 10){
            HStack {
                Text(station.name ?? "")
                    .font(Font.Atures(.bold, size: 20))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Colors.yellow)
            }
            
            Text("\(CGPoint(x: mainStation?.coordinateX ?? 0.0, y:  mainStation?.coordinateY ?? 0.0).distance(to:CGPoint(x: station.coordinateX!, y:  station.coordinateY!)))EUS")
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.darkPurple)
            Text("\(station.capacity ?? 0)/\(station.stock ?? 0)")
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.purple)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Colors.lightBlue, Colors.blue, Colors.darkBlue]), startPoint: .topTrailing, endPoint: .bottomLeading)
                .clipShape(CustomShape())
        )
        .cornerRadius(10)
        .swipeActions {
            Button(action: {
                self.favoritesViewModel.updateFavoriteStation(spaceStation: station)
            }) {
                Text(Constants.Favorites.remove)
                Image(systemName: "trash.fill")
            }
            .tint(.red)
        }
        
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
