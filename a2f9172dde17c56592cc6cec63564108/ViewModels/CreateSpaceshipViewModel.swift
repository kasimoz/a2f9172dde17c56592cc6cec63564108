//
//  CreateSpaceshipViewModel.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 17.11.2021.
//

import Foundation
import Combine
import CoreData

class CreateSpaceshipViewModel: ObservableObject {
    @Published var isExistSpaceship: Bool = false
    @Published var searchQuery: String = ""
    @Published var success : Bool = false
    @Published var saveError: NSError? = nil
    
    private var searchCancellable :AnyCancellable? = nil
    
    private var viewContext : NSManagedObjectContext? = nil
    
    
    func setup(_ viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
    
    func addSpaceship(spaceshipName : String, properties: [Property]) {
        let newItem = Spaceship(context: viewContext!)
        newItem.name = spaceshipName
        newItem.mainStation = Constants.MainStation.name
        newItem.capacity = Int32(properties.filter({$0.name == Constants.PropertyList.capacity}).first?.value ?? 1) * 10000
        newItem.durability = Int32(properties.filter({$0.name == Constants.PropertyList.durability}).first?.value ?? 1) * 10000
        newItem.speed = Int32(properties.filter({$0.name == Constants.PropertyList.speed}).first?.value ?? 1) * 20
        newItem.damage = Int32(100)
        
        do {
            try viewContext!.save()
            self.success = true
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            self.saveError = nsError
        }
    }
    
    func fetchSpaceship(){
        let fetchRequest: NSFetchRequest<Spaceship>
        fetchRequest = Spaceship.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try viewContext!.fetch(fetchRequest).count
            self.isExistSpaceship = count != 0
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    public func clearAllCoreData() {
        Constants.Entities.list.forEach(clearDeepObjectEntity)
        self.isExistSpaceship = false
        self.success = false
    }
    
    private func clearDeepObjectEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext!.execute(deleteRequest)
            try viewContext!.save()
        } catch {
            print ("There was an error")
        }
    }
    
}

