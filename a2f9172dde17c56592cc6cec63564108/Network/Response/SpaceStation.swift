//
//  SpaceStation.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import Foundation
struct SpaceStation : Codable, Identifiable {
    var id = UUID().uuidString
    var name : String?
    var coordinateX : Double?
    var coordinateY : Double?
    var capacity : Int?
    var stock : Int?
    var need : Int?
    var image : String?
    var isFavorite : Bool = false

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
        image = Constants.Planet.list[name == Constants.MainStation.name ? 0 : Int.random(in: 1..<10)]
    }
    
    init(id :String, name: String?, image: String?, coordinateX : Double?, coordinateY : Double?, capacity : Int?, stock : Int, need : Int?, isFavorite: Bool){
        self.id = id
        self.name = name
        self.image = image
        self.coordinateX = coordinateX
        self.coordinateY = coordinateY
        self.capacity = capacity
        self.stock = stock
        self.need = need
        self.isFavorite = isFavorite
    }

}
