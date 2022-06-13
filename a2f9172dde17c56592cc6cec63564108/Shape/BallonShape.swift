//
//  BallonShape.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 20.11.2021.
//

import SwiftUI

struct BallonShape: Shape {
   
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY), control: CGPoint(x: rect.maxX - 10, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.maxY - 10))
        }
    }
}
