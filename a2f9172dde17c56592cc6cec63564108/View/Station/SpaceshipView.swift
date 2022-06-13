//
//  SpaceshipView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

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
