//
//  SavedViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 28.05.2024.
//

import UIKit

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSave", for: indexPath) as! SaveTableViewCell
        
        return cell
    }
    
}
