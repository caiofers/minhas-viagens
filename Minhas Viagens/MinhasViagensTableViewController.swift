//
//  ViewController.swift
//  Minhas Viagens
//
//  Created by Caio Fernandes on 26/03/21.
//

import UIKit

class MinhasViagensTableViewController: UITableViewController {
    
    var listOfPlaces: [Dictionary <String, String>] = []
    var navigation = "add"
    private var listObj = Places()
    
    override func viewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigation = "add"
        listOfPlaces = listObj.getAllPlaces()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseCell = "reuseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath)
        let place = listOfPlaces[indexPath.row]
        cell.textLabel?.text = place["local"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listObj.remove(at: indexPath.row)
            listOfPlaces = listObj.getAllPlaces()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigation = "list"
        performSegue(withIdentifier: "seeMap", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeMap" {
            let viewDestiny = segue.destination as! MapViewController
            if navigation == "list" {
                if let indexForItem = sender {
                    viewDestiny.place = listOfPlaces[indexForItem as! Int]
                    viewDestiny.isPlaceView = true
                }
            } else {
                viewDestiny.place = [:]
                viewDestiny.isPlaceView = false
            }
        }
    }
    
}

