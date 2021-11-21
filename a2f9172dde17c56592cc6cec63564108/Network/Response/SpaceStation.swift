//
//  SpaceStation.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import Foundation
struct SpaceStation : Codable {
    let name : String?
    let coordinateX : Double?
    let coordinateY : Double?
    let capacity : Int?
    let stock : Int?
    let need : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case coordinateX = "coordinateX"
        case coordinateY = "coordinateY"
        case capacity = "capacity"
        case stock = "stock"
        case need = "need"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        coordinateX = try values.decodeIfPresent(Double.self, forKey: .coordinateX)
        coordinateY = try values.decodeIfPresent(Double.self, forKey: .coordinateY)
        capacity = try values.decodeIfPresent(Int.self, forKey: .capacity)
        stock = try values.decodeIfPresent(Int.self, forKey: .stock)
        need = try values.decodeIfPresent(Int.self, forKey: .need)
    }

}
