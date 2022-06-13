//
//  StationExtension.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import SwiftUI

extension Array where Element == Station {
    func toStaionList() -> [SpaceStation]? {
        return self.compactMap {
            return SpaceStation(id: $0.id ?? UUID().uuidString,
                                name: $0.name,
                                image: $0.image,
                                coordinateX: $0.coordinateX,
                                coordinateY: $0.coordinateY,
                                capacity: Int($0.capacity),
                                stock: Int($0.stock),
                                need: Int($0.need),
                                isFavorite: $0.favorite
            )
        }
    }
}

extension Array where Element == SpaceStation {
    func calculateRemainingTime(mainStation : SpaceStation) -> Int{
        let list = self.filter({$0.need != 0})
        let mainStationCoordinate = CGPoint(x: mainStation.coordinateX ?? 0.0, y: mainStation.coordinateY ?? 0.0)
        let remainingTime = list.compactMap({mainStationCoordinate.distance(to: CGPoint(x: $0.coordinateX ?? 0.0,y: $0.coordinateY ?? 0.0))}).reduce(0, +)
        return remainingTime
    }
    
    func allDeliveredSuccesfull () -> Bool{
       return self.filter({$0.need != 0}).isEmpty
    }
}
