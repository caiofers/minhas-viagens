//
//  ViewController.swift
//  Minhas Viagens
//
//  Created by Caio Fernandes on 26/03/21.
//

import UIKit

class MinhasViagensTableViewController: UITableViewController {
    
    var listOfPlaces: [String] = []
    private var listObj = Places()
    
    override func viewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        
        cell.textLabel?.text = listOfPlaces[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listObj.remove(at: indexPath.row)
            listOfPlaces = listObj.getAllPlaces()
            tableView.reloadData()
        }
    }
    
}

