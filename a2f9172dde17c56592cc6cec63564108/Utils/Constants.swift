//
//  Constants.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import Foundation

open class Constants {
    
    enum PropertyList {
        static let durability = "Dayanıklılık"
        static let speed = "Hız"
        static let capacity = "Kapasite"
    }
    
    enum MainStation {
        static let name = "Dünya"
    }
    
    enum Tabs {
        static let station = "Istasyon"
        static let favorites = "Favoriler"
    }
    
    enum TabsImage {
        static let station = "antenna.radiowaves.left.and.right"
        static let favorites = "star.fill"
    }
    
    enum Damage{
        static let UGS = "UGS"
        static let EUS = "EUS"
        static let DS = "DS"
    }
    
    enum Planet {
        static let list = ["planet1","planet2","planet3","planet4","planet5","planet6","planet7","planet8","planet9","planet10"]
    }
    
    enum Entities {
        static let list = ["Station", "Spaceship"]
    }
                           
    enum CreateSpaceShip {
        static let ok = "Tamam"
        static let spaceshipName = "Uzay Aracı Adı"
        static let pointsShared = "Dağıtılacak Puan"
        static let description = "Göreve başlamak için uzay aracını oluşturmalısın."
        static let continuee = "Devam Et"
        static let emptySpaceshipName = "Uzay aracına isim vermelisin"
        static let totalPointsNotCorrect =  "Uzay aracını oluştururken özelliklerin toplamı 15 puan olacak şekilde dağıtman gerekmektedir, özelliklerden herhangi birisi sıfır olamaz."
    }
    
    enum Stations {
        static let stationName = "İstasyon Adı"
        static let travel = "Seyahat Et"
        static let missionCompleted = "Görev Başarılı"
        static let missionFailed = "Görev Başarısız"
        static let returnToWorld = "Dünya'ya Dön"
        static let damageMessage = "Uzay aracı hasarı sıfıra inmiştir"
        static let ugsMessage = "Dağıtılacak uzay giysisi sayısı ihtiyaç olandan azdır"
        static let eusMessage = "Teslimat için yeterli uzay süren bulunmamaktadır"
    }
    
    enum Favorites {
        static let title = "Favoriler"
        static let remove = "Sil"
    }
    
}
                           
