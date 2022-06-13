//
//  InformationView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

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
