//
//  NameView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

struct NameView : View {
    @Binding var spaceshipName: String
    var body: some View {
        HStack (spacing : 10){
            Image(systemName: "airplane.circle")
                .foregroundColor(Colors.lightPurple)
            TextField("", text: $spaceshipName)
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.darkPurple)
                .placeHolder(
                    Text(Constants.CreateSpaceShip.spaceshipName)
                        .font(Font.Atures(.regular, size: 14))
                        .foregroundColor(Colors.lightPurple)
                    , show: spaceshipName.isEmpty)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Colors.orange, radius: 2)
        .padding()
    }
}
