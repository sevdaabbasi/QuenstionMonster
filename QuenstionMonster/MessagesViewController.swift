//
//  MessagesViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 20.04.2024.
//

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newMessageClicked(_ sender: Any) {
        performSegue(withIdentifier: "chatSegue", sender: self)
    }
    
}
