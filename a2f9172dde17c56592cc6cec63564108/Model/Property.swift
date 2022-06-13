//
//  Property.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import SwiftUI

struct Property : Identifiable {
    var id = UUID().uuidString
    var type : PropertyType
    var name : String
    var color : Color
    var offset : CGFloat = 0
    var value : Int = 0
}

enum PropertyType {
    case capacity
    case durability
    case speed
}

