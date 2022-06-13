//
//  SearchView.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

struct SearchView : View {
    @Binding var searchQuery: String
    var body: some View {
        HStack (spacing : 10){
            Image(systemName: "magnifyingglass")
                .foregroundColor(Colors.purple)
            TextField("", text: $searchQuery)
                .font(Font.Atures(.regular, size: 14))
                .foregroundColor(Colors.darkPurple)
                .placeHolder(
                    Text(Constants.Stations.stationName)
                        .font(Font.Atures(.regular, size: 14))
                        .foregroundColor(Colors.purple)
                    , show: searchQuery.isEmpty)
        }
        .frame(height: 48)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Colors.pink, radius: 5)
        .padding()
    }
}
