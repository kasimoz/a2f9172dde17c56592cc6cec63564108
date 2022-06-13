//
//  FavoritesViewModel.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 20.11.2021.
//

import Foundation
import CoreData

class FavoritesViewModel: ObservableObject {
    @Published var spaceStations: [SpaceStation] = []
    @Published var mainStation: SpaceStation? = nil
    
    private var viewContext : NSManagedObjectContext? = nil
    
    func setup(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func fetchFavoriteStations(){
        let fetchRequest: NSFetchRequest<Station>
        fetchRequest = Station.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "favorite == %d", true
        )

        do {
            let objects = try viewContext!.fetch(fetchRequest)
            let list = objects.toStaionList() ?? []
            self.mainStation = list.filter({$0.name == Constants.MainStation.name}).first
            self.spaceStations = list.filter({$0.name != Constants.MainStation.name})
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateFavoriteStation(spaceStation: SpaceStation){
        let fetchRequest: NSFetchRequest<Station>
        fetchRequest = Station.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", spaceStation.id
        )
        fetchRequest.fetchLimit = 1
        do {
            let object = try viewContext!.fetch(fetchRequest).first
            object?.favorite = !(object?.favorite ?? false)
            try viewContext?.save()
            self.fetchFavoriteStations()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
     }
}
