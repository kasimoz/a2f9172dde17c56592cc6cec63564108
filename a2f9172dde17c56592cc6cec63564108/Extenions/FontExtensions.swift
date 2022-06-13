//
//  FontExtensions.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import SwiftUI

extension Font {

    public enum AturesType: String {
        case light = "100"
        case regular = "300"
        case medium = "500"
        case bold = "700"
        case black = "900"
    }

    static func Atures(_ type: AturesType = .regular, size: CGFloat = UIFont.systemFontSize) -> Font {
        return Font.custom("Atures\(type.rawValue)PERSONALUSEONLY", size: size)
    }
}
