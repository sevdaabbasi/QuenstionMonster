//
//  QuestionViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 20.04.2024.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.userNameLabel.text = "test"
        cell.likeLabel.text = "0"
        cell.explanationLabel.text = "açıklama"
        cell.userImageView.image = UIImage(named: "Plus")
        return cell
    }
    
    @IBAction func AddQuestionClicked(_ sender: Any) {
        performSegue(withIdentifier: "addQuestionSegue", sender: self)
    }
    


}
