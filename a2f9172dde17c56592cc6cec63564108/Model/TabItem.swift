//
//  TabItem.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

struct TabItem : Identifiable, Hashable {
    var id = UUID().uuidString
    var image : String
    var name : String
    var type : TabType
}

enum TabType : String {
    case station = "station"
    case favorites = "favorites"
}


