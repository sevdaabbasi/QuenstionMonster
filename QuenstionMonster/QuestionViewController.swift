//
//  QuestionViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 20.04.2024.
//

import UIKit
import Firebase

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    

    @IBOutlet weak var tableView: UITableView!
    
    var userNameArray = [String]()
    var userCommentArray = [String]()
    var saveArray = [Int]()
    var userImage = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        if indexPath.row < userCommentArray.count {
                cell.explanationLabel.text = userCommentArray[indexPath.row]
            } else {
                cell.explanationLabel.text = " "
            }
        if indexPath.row < saveArray.count {
            cell.saveLabel.text = String(saveArray[indexPath.row])
            } else {
                cell.explanationLabel.text = "000"
            }
        
        cell.userNameLabel.text = userNameArray[indexPath.row]
       // cell.saveLabel.text = String(saveArray[indexPath.row])
      //  cell.explanationLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.image = UIImage(named: "Plus")
        return cell
    }
    
    @IBAction func AddQuestionClicked(_ sender: Any) {
        performSegue(withIdentifier: "addQuestionSegue", sender: self)
        
       
    }
    
    
    // Verileri Çekme
    
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                      let documentID =  document.documentID
                        print(documentID)
                        
                        if let userNamePostedBy =  document.get("postedBy") as? String{
                            self.userNameArray.append(userNamePostedBy)
                            
                        }
                        if let userComment =  document.get("postComment") as? String{
                            self.userCommentArray.append(userComment)
                            
                        }
                        if let saved =  document.get("save") as? Int{
                            self.saveArray.append(saved)
                            
                        }
                        if let imageUrl =  document.get("imageUrl") as? String{
                            self.userImage.append(imageUrl)
                            
                        }
                    }
                    self.tableView.reloadData()
                }
               
            }
        }
       
    }


}
