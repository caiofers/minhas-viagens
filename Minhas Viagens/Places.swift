//
//  Places.swift
//  Minhas Viagens
//
//  Created by Caio Fernandes on 26/03/21.
//

import Foundation

class Places{
    private var listOfPlaces: [String] = []
    private let key = "traveled_places"
    
    func add(place: String) -> Void {
        listOfPlaces = getAllPlaces()
        listOfPlaces.append(place)
        UserDefaults.standard.set(listOfPlaces, forKey: key)
    }
    
    func remove(placeIndex: Int) -> Void {
        listOfPlaces = getAllPlaces()
        listOfPlaces.remove(at: placeIndex)
        UserDefaults.standard.set(listOfPlaces, forKey: key)
    }
    
    func getAllPlaces() -> [String] {
        if let list = UserDefaults.standard.object(forKey: key) {
            return list as! [String]
        }
        return []
    }
}
