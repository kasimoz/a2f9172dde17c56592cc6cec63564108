//
//  MissionFailedView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

struct MissionFailedView: View {
    @Binding var showView : ShowView
    var message : String
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .trim(from: 0.07, to: 0.43)
                    .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [1]))
                    .frame(width: 158, height: 158)
                    .rotationEffect(.init(degrees: -5))
                
                Circle()
                    .trim(from: 0.07, to: 0.43)
                    .stroke(.red, style: StrokeStyle(lineWidth: 10))
                    .frame(width: 172, height: 172)
                    .rotationEffect(.init(degrees: -5))
                
                Circle()
                    .trim(from: 0.57, to: 0.93)
                    .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [1]))
                    .frame(width: 158, height: 158)
                    .rotationEffect(.init(degrees: -5))
                
                Circle()
                    .trim(from: 0.57, to: 0.93)
                    .stroke(.red, style: StrokeStyle(lineWidth: 10))
                    .frame(width: 172, height: 172)
                    .rotationEffect(.init(degrees: -5))
                
                ForEach(1..<13){index in
                    Star(count: index)
                        .rotationEffect(.init(degrees: -5))
                }
                
                Text(Constants.Stations.missionFailed)
                    .font(Font.Atures(.black, size: 22))
                    .foregroundColor(.white)
                    .padding(16)
                    .background(.red)
                    .clipShape(Rectangle())
                    .cornerRadius(5)
                    .padding(4)
                    .overlay(
                        Rectangle()
                            .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [1]))
                            .cornerRadius(5)
                    )
                    .padding(4)
                    .border(Color.red, width: 3)
                    .cornerRadius(5)
                    .rotationEffect(.init(degrees: -5))
            }
            Text(message)
                .font(Font.Atures(.bold, size: 16))
                .foregroundColor(.white)
                .lineSpacing(8)
                .padding()
            Button {
                showView = .empty
            } label: {
                Text(Constants.Stations.returnToWorld)
                    .font(Font.Atures(.bold, size: 18))
                    .padding(16)
                    .background(Colors.tabColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 32)
            
        }
    }
}

struct Star : View {
    var count: Int
    var body: some View{
        VStack{
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor([2,4,8,10].contains(count) ? .clear : .red)
                .rotationEffect(.radians(-(Double.pi*2 / 12 * Double(count))))
            Spacer()
        }
        .padding()
        .rotationEffect(.radians((Double.pi * 2 / 12 * Double(count))))
        .frame(width: 172, height: 172)
    }
}
