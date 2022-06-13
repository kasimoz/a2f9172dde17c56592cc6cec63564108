//
//  CustomTabBar.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

struct CustomTabBar: View {
    var animation: Namespace.ID
    var tabs : [TabItem]
    
    @Binding var currentTab: TabType
    var body: some View {
        HStack(spacing:0){
            ForEach(tabs, id:\.self){ tab in
                TabButton(tab: tab, animation: animation, currentTab: $currentTab){ pressedTab in
                    withAnimation{
                        currentTab = pressedTab
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}

struct TabButton: View {
    var tab: TabItem
    var animation :Namespace.ID
    @Binding var currentTab : TabType
    
    var onTap : (TabType) -> ()
    var body: some View {
        VStack{
            Image(systemName: tab.image)
                .foregroundColor(currentTab == tab.type ? Colors.darkPurple : Colors.yellow)
                .frame(width: 45, height: 45)
                .background(
                    ZStack {
                        if currentTab == tab.type {
                            Circle()
                                .fill(Colors.orange)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                )
                .frame(width: getRect().width / 2)
                .contentShape(Rectangle())
                .onTapGesture {
                    onTap(tab.type)
                }
            
            Text("\(tab.name)")
                .font(Font.Atures(currentTab == tab.type ? .bold : .regular, size: 14))
                .foregroundColor(currentTab == tab.type ? Colors.orange : Colors.yellow)
        }
    }
}
