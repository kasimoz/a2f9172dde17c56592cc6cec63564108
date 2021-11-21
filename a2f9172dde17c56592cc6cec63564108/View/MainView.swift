//
//  MainView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

struct Main2View: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var currentTab : Tab = .Station
    @Namespace var animation
    
    
    
    var body: some View {
        ZStack{
            TabView(selection: $currentTab){
               /* StationView()
                    .environment(\.managedObjectContext, viewContext)
                    .tag(Tab.Station)
                
                FavoritesView()
                    .environment(\.managedObjectContext, viewContext)
                    .tag(Tab.Favorites)*/
            }
            
            CustomTabBar(animation: animation, currentTab : $currentTab)
        }
    }
}

struct Main2View_Previews: PreviewProvider {
    static var previews: some View {
        Main2View()
    }
}

enum Tab : String, CaseIterable {
    case Station = "antenna.radiowaves.left.and.right"
    case Favorites = "star.fill"
}
