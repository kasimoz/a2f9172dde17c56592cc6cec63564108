//
//  MainView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var createSpaceshipViewModel : CreateSpaceshipViewModel
    @State var currentTab : TabType = .station
    @Namespace var animation
    @State private var tabs = [
        TabItem(image: Constants.TabsImage.station, name: Constants.Tabs.station, type: .station),
        TabItem(image: Constants.TabsImage.favorites, name: Constants.Tabs.favorites, type: .favorites)
    ]
    
    init(createSpaceshipViewModel : CreateSpaceshipViewModel){
        self.createSpaceshipViewModel = createSpaceshipViewModel
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        GeometryReader{proxy in
            VStack(alignment: .trailing, spacing: 0){
                TabView(selection: $currentTab){
                    StationView(createSpaceshipViewModel: self.createSpaceshipViewModel)
                        .environment(\.managedObjectContext, viewContext)
                        .tag(TabType.station)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Colors.backgroundColor)
                    FavoritesView()
                        .environment(\.managedObjectContext, viewContext)
                        .tag(TabType.favorites)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Colors.backgroundColor)
                }
                
                CustomTabBar(animation: animation, tabs: tabs, currentTab : $currentTab)
                    .background(Colors.tabColor)

                
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}

