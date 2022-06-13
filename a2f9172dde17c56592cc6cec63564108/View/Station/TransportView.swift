//
//  TransportView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

struct TransportView: View {
    @State var offset : CGFloat = 0
    @Binding var showView : ShowView
    @Binding var duration : Double
    var image: String
    var body: some View {
        VStack{
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                Line()
                    .stroke(Colors.lightPurple, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .miter , dash: [5]))
                    .frame(height: 1)
                    .padding(.horizontal)
                Image(image)
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
