//
//  AppRootView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

struct AppRootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var offsetX : CGFloat = 0
    @State var offsetY : CGFloat = 100
    @State var starHeight : CGFloat = 5
    
    @State var show : Bool = false
    
    var body: some View {
        Group {
            /// splash screen
            GeometryReader { proxy in
                let size = proxy.frame(in: .global)
                ZStack(alignment: .topLeading) {
                    /// stars
                    ForEach(1...50, id: \.self) {_ in
                        let positionX =  CGFloat.random(in: 0..<size.width)
                        let positionY =  CGFloat.random(in: 0..<size.height)
                        let widthHeight = CGFloat.random(in: 1..<5)
                        Circle()
                            .fill(Colors.yellow)
                            .frame(width: widthHeight, height: widthHeight)
                            .position(x:  positionX, y: positionY)
                    }
                    
                    /// falling star
                    BallonShape()
                        .fill(Colors.yellow)
                        .frame(width: starHeight, height: starHeight / 2)
                        .offset(x: offsetX, y: offsetY)
                        .animation(.easeIn(duration: 2), value: offsetX)
                        .onAnimationCompleted(for: offsetX) {
                            show = true
                        }
                        .animation(.easeIn(duration: 2), value: offsetY)
                        .shadow(color: .white.opacity(0.5), radius: 5)
                        .animation(.easeIn(duration: 2), value: starHeight)
                        
                        .onAppear(){
                            offsetX = size.width
                            offsetY = size.height * 0.5
                            starHeight = 150
                        }
                    ///  the world
                    Image(Constants.Planet.list[0])
                        .resizable()
                        .frame(width: size.width, height: size.width)
                        .shadow(color: .white.opacity(0.5), radius: 72)
                        .position(x: size.width * 0.3, y: size.height)
                    
                    /// the saturn
                    Image(Constants.Planet.list[4])
                        .resizable()
                        .frame(width: size.width * 0.3, height: size.width * 0.3)
                        .position(x: 16, y: size.height * 0.5)
                    /// the sun
                    Circle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.yellow, Colors.yellow, Colors.orange]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: size.width * 0.4, height: size.width * 0.4)
                        .position(x: size.width , y: size.height * 0.3)
                        .shadow(color: .white.opacity(0.5), radius: 36)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Colors.navyBlue)
            .overlay(){
                if show {
                    CreateSpaceshipView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}

