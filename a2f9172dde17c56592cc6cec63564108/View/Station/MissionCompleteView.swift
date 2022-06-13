//
//  MissionCompleteView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

struct MissionCompleteView: View {
    @Binding var showView : ShowView
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Colors.darkBlue)
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .foregroundColor(Colors.darkBlue)
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Colors.darkBlue)
                Spacer()
            }.padding()
            Text(Constants.Stations.missionCompleted)
                .font(Font.Atures(.black, size: 24))
                .foregroundColor(Colors.darkBlue)
                .padding()
            Button {
                showView = .empty
            } label: {
                Text(Constants.Stations.returnToWorld)
                    .font(Font.Atures(.bold, size: 18))
                    .padding(16)
                    .background(Colors.pink)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            
        }
    }
}
