//
//  StationViewModel.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 18.11.2021.
//

import Foundation
import Combine
import CoreData

class StationViewModel: ObservableObject {
    @Published var spaceStations: [SpaceStation] = []
    @Published var searchQuery: String = ""
    @Published var success : Bool = false
    @Published var error: Error? = nil
    @Published var spaceship: Spaceship? = nil
    @Published var mainStation: SpaceStation? = nil
    @Published var currentIndex: Int = 0
    private var defaultStations : [SpaceStation] = []
    private var searchCancellable :AnyCancellable? = nil
    
    private var networkManager: NetworkManager? = nil
    private var viewContext : NSManagedObjectContext? = nil
    
    func setup(_ networkManager: NetworkManager, viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
        self.networkManager = networkManager
        
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: {[weak self]  str in
                guard let strongSelf = self else { return }
                if str.isEmpty {
                    strongSelf.spaceStations = strongSelf.defaultStations
                    strongSelf.currentIndex = 0
                }else{
                    strongSelf.searchStation()
                }
            })
    }
    
    func requestFetchStations() {
        let stations = fetchStations()
        if stations.isEmpty {
            self.networkManager?.fetchSpaceStations() { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let stationsResponse):
                    strongSelf.spaceStations = stationsResponse.filter({$0.name != strongSelf.spaceship?.mainStation})
                    strongSelf.defaultStations = stationsResponse.filter({$0.name != strongSelf.spaceship?.mainStation})
                    strongSelf.mainStation = stationsResponse.filter({$0.name == strongSelf.spaceship?.mainStation}).first
                    DispatchQueue.main.async() {
                        stationsResponse.forEach{ item in
                            strongSelf.addStation(station: item)
                        }
                    }
                case .failure(let errorResponse):
                    strongSelf.error = errorResponse
                }
            }
        }else{
            self.spaceStations = stations.filter({$0.name != self.spaceship?.mainStation})
            self.defaultStations = stations.filter({$0.name != self.spaceship?.mainStation})
            self.mainStation = stations.filter({$0.name == self.spaceship?.mainStation}).first
        }
    }
    
    func searchStation(){
        self.spaceStations = defaultStations.filter({$0.name?.lowercased().contains(searchQuery.lowercased()) ?? true})
        self.currentIndex = 0
    }
    
    func addStation(station:SpaceStation) {
        let newItem = Station(context: viewContext!)
        newItem.name = station.name
        newItem.image = station.image
        newItem.id = station.id
        newItem.coordinateX = station.coordinateX ?? 0.0
        newItem.coordinateY = station.coordinateY ?? 0.0
        newItem.stock = Int32(station.stock ?? 0)
        newItem.need = Int32(station.need ?? 0)
        newItem.capacity = Int32(station.capacity ?? 0)
        newItem.favorite = station.isFavorite
        do {
            try viewContext!.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func fetchStations() -> [SpaceStation]{
        let fetchRequest: NSFetchRequest<Station>
        fetchRequest = Station.fetchRequest()
        
        /*fetchRequest.predicate = NSPredicate(
         format: "need != %d", 0
         )*/
        
        do {
            let objects = try viewContext!.fetch(fetchRequest)
            return objects.toStaionList() ?? []
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return []
    }
    
    func fetchSpaceship(){
        let fetchRequest: NSFetchRequest<Spaceship>
        fetchRequest = Spaceship.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let object = try viewContext!.fetch(fetchRequest).first
            self.spaceship = object
            self.requestFetchStations()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateSpaceship(spaceship: Spaceship){
        let fetchRequest: NSFetchRequest<Spaceship>
        fetchRequest = Spaceship.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let object = try viewContext!.fetch(fetchRequest).first
            object?.damage = spaceship.damage
            object?.mainStation = spaceship.mainStation
            object?.durability = spaceship.durability
            object?.speed = spaceship.speed
            object?.capacity = spaceship.capacity
            try viewContext?.save()
            self.requestFetchStations()
            self.searchQuery = ""
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateStation(spaceStation: SpaceStation){
        let fetchRequest: NSFetchRequest<Station>
        fetchRequest = Station.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", spaceStation.id
        )
        fetchRequest.fetchLimit = 1
        
        do {
            let object = try viewContext!.fetch(fetchRequest).first
            object?.capacity = Int32(spaceStation.capacity!)
            object?.need = Int32(spaceStation.need!)
            object?.stock = Int32(spaceStation.stock!)
            try viewContext?.save()
            self.requestFetchStations()
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
            self.requestFetchStations()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateAllViews(travelStation : SpaceStation, need : Int, eus: Double){
        self.spaceship?.mainStation = travelStation.name
        self.spaceship?.speed -= Int32(eus)
        self.spaceship?.capacity -= Int32(need)
        self.updateStation(spaceStation: travelStation)
        self.updateSpaceship(spaceship: self.spaceship!)
        self.fetchSpaceship()
    }
}
