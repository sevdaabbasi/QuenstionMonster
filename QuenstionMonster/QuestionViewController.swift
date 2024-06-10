//
//  QuestionViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 20.04.2024.
//

import UIKit
import Firebase
import SDWebImage

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userNameArray = [String]()
    var userCommentArray = [String]()
    var saveArray = [Int]()
    var userImage = [String]()
    var explanationArray = [String]()
    var documentIDArray = [String]()
    var userSavedPosts = [String]()
    var currentUserID: String?
    var answerArray = [String]() // Answer array'i tanımla
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Current user ID'yi alın
        if let user = Auth.auth().currentUser {
            currentUserID = user.uid
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.userNameLabel.text = userNameArray[indexPath.row]
        
        if indexPath.row < userCommentArray.count {
            cell.explanationLabel.text = userCommentArray[indexPath.row]
        } else {
            cell.explanationLabel.text = " "
        }
        
        if indexPath.row < saveArray.count {
            cell.saveLabel.text = String(saveArray[indexPath.row])
        } else {
            cell.saveLabel.text = "000"
        }
        
        if indexPath.row < explanationArray.count {
            cell.explanationLabel.text = explanationArray[indexPath.row]
        } else {
            cell.explanationLabel.text = "Explanation not available"
        }
        
        if indexPath.row < answerArray.count { // Eğer answerArray tanımlıysa, hücreye yazdır
            cell.answerLabel.text = answerArray[indexPath.row]
        } else {
            cell.answerLabel.text = "Answer not available"
        }
        
        cell.userImageView.sd_setImage(with: URL(string: self.userImage[indexPath.row]))
        cell.documentID = documentIDArray[indexPath.row]
        cell.delegate = self
        cell.isSaved = userSavedPosts.contains(documentIDArray[indexPath.row])
        
        return cell
    }
    
    @IBAction func AddQuestionClicked(_ sender: Any) {
        performSegue(withIdentifier: "addQuestionSegue", sender: self)
    }
    
    func getDataFromFirestore() {
        guard let userID = currentUserID else { return }
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    self.userNameArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.saveArray.removeAll()
                    self.userImage.removeAll()
                    self.explanationArray.removeAll()
                    self.documentIDArray.removeAll()
                    self.answerArray.removeAll() // answerArray'i temizle
                    
                    for document in snapshot.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let userNamePostedBy = document.get("postedBy") as? String {
                            self.userNameArray.append(userNamePostedBy)
                        }
                        if let userComment = document.get("postComment") as? String {
                            self.userCommentArray.append(userComment)
                        }
                        if let saved = document.get("save") as? Int {
                            self.saveArray.append(saved)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImage.append(imageUrl)
                        }
                        if let explanation = document.get("Explanation") as? String {
                            self.explanationArray.append(explanation)
                        }
                        if let answer = document.get("Answer") as? String {
                            self.answerArray.append(answer) // answerArray'e ekle
                        }
                    }
                    self.getUserSavedPosts(userID: userID)
                }
            }
        }
    }
    
    func getUserSavedPosts(userID: String) {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Users").document(userID).collection("SavedPosts").getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                self.userSavedPosts.removeAll()
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        self.userSavedPosts.append(document.documentID)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension QuestionViewController: TableViewCellDelegate {
    func didTapSaveButton(documentID: String, isSaved: Bool) {
        guard let userID = currentUserID else { return }
        
        let fireStoreDatabase = Firestore.firestore()
        let userDocumentRef = fireStoreDatabase.collection("Users").document(userID).collection("SavedPosts").document(documentID)
        let postDocumentRef = fireStoreDatabase.collection("Posts").document(documentID)
        
        if isSaved {
            // Eğer daha önce kaydedilmişse, kayıttan çıkar
            userDocumentRef.delete { error in
                if let error = error {
                    print("Error removing save: \(error)")
                } else {
                    postDocumentRef.updateData(["save": FieldValue.increment(Int64(-1))]) { error in
                        if let error = error {
                            print("Error updating save count: \(error)")
                        } else {
                            self.getDataFromFirestore()
                        }
                    }
                }
            }
        } else {
            // Eğer daha önce kaydedilmemişse, kaydet
            userDocumentRef.setData([:]) { error in
                if let error = error {
                    print("Error saving post: \(error)")
                } else {
                    postDocumentRef.updateData(["save": FieldValue.increment(Int64(1))]) { error in
                        if let error = error {
                            print("Error updating save count: \(error)")
                        } else {
                            self.getDataFromFirestore()
                        }
                    }
                }
            }
        }
    }
}
