//
//  UserSelectionViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 11.05.2024.
//
import UIKit

protocol UserSelectionDelegate: AnyObject {
    func didSelectUser(_ user: String)
}

class UserSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    weak var delegate: UserSelectionDelegate?
    let users = ["User 1", "User 2", "User 3"]
    
    // TableView'a dair gerekli kodlar
    
    // TableView Delegate ve DataSource metodları
}
