//
//  TitleView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

struct TitleView: View {
    @Binding var sharedValue: Int
    var body: some View {
        VStack{
            Text(Constants.CreateSpaceShip.description)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.purple)
                .padding()
            Line()
                .stroke(Color.purple, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter , dash: [10]))
                .frame(height: 1)
                .padding(.horizontal)
            HStack{
                Text(Constants.CreateSpaceShip.pointsShared)
                    .font(Font.Atures(.bold, size: 18))
                    .foregroundColor(Colors.purple)
                    .padding()
                Spacer()
                Text("\(sharedValue)")
                    .font(Font.Atures(.black, size: 18))
                    .foregroundColor(Colors.purple).padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Colors.yellow)
        )
        .padding(.horizontal)
    }
}
