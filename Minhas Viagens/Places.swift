//
//  Places.swift
//  Minhas Viagens
//
//  Created by Caio Fernandes on 26/03/21.
//

import Foundation

class Places{
    private var listOfPlaces: [Dictionary<String, String>] = []
    private let key = "traveled_places"
    
    func add(place: Dictionary<String, String>) -> Void {
        listOfPlaces = getAllPlaces()
        listOfPlaces.append(place)
        UserDefaults.standard.set(listOfPlaces, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func remove(at placeIndex: Int) -> Void {
        listOfPlaces = getAllPlaces()
        listOfPlaces.remove(at: placeIndex)
        UserDefaults.standard.set(listOfPlaces, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getAllPlaces() -> [Dictionary <String, String>] {
        if let list = UserDefaults.standard.object(forKey: key) {
            return list as! [Dictionary <String, String>]
        }
        return []
    }
}
