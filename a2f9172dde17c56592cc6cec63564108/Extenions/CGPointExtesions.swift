//
//  CGPointExtesions.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 20.11.2021.
//

import SwiftUI

extension CGPoint {
    
    func distance(to point: CGPoint) -> Int {
        return Int(sqrt(pow((point.x - x), 2) + pow((point.y - y), 2)))
    }
}
