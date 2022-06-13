//
//  CustomShape.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 20.11.2021.
//

import SwiftUI

struct CustomShape: Shape {
   
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            
            let pt1 = CGPoint(x : 0, y: 0)
            let pt2 = CGPoint(x : 0, y: rect.height)
            let pt3 = CGPoint(x : rect.width, y: rect.height)
            let pt4 = CGPoint(x : rect.width, y: 0)
            let pt5 = CGPoint(x : rect.width/2, y: 0)
            let pt6 = CGPoint(x : rect.width/2, y: rect.height)
            let pt7 = CGPoint(x : 0, y: rect.height/2)
            let pt8 = CGPoint(x : rect.width, y: rect.height/2)
            
            path.move(to: pt1)
            path.addLine(to: pt2)
            path.addLine(to: pt3)
            path.addLine(to: pt4)
            
            path.move(to: pt5)
            path.addArc(center: pt5, radius: 10, startAngle: .init(degrees: -180), endAngle: .init(degrees: 180), clockwise: false)
            
            path.move(to: pt6)
            path.addArc(center: pt6, radius: 10, startAngle: .init(degrees: 0), endAngle: .init(degrees: 360), clockwise: false)
            
            path.move(to: pt7)
            path.addArc(center: pt7, radius: 10, startAngle: .init(degrees: -90), endAngle: .init(degrees: 90), clockwise: false)
            
            path.move(to: pt8)
            path.addArc(center: pt8, radius: 10, startAngle: .init(degrees: 90), endAngle: .init(degrees: -90), clockwise: false)
    
        }
    }
}
