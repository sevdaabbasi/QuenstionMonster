//
//  AddQuestionViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 12.05.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class AddQuestionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var textFieldClass: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textFieldLesson: UITextField!
    
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var textFieldNot: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        // pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput:  String, completion: (() -> Void)? = nil ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            completion?()
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    @IBAction func addQuestionButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("media")
        if let userName = UserDefaults.standard.string(forKey: "userName"){
            if let data = imageView.image?.jpegData(compressionQuality: 0.5){
                
                let uuid = UUID().uuidString
                let imageReference = mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata: nil) { (metadata, error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    }else{
                        imageReference.downloadURL { (url, error )  in
                            if error == nil {
                                
                                let imageUrl  = url?.absoluteString
                                
                                
                                // DATABASE - Firestore Database
                                
                                let firestoreDatabase = Firestore.firestore()
                                var firestoreReferance : DocumentReference? = nil
                                let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!,
                                                     
                                                     "Explanation" : self.textFieldNot.text!,"Class" : self.textFieldClass.text!,"Lesson" : self.textFieldLesson.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                                
                                firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                    else {
                                        
                                        self.imageView.image = UIImage(named: "Plus")
                                        self.textFieldNot.text = ""
                                        self.textFieldClass.text = ""
                                        self.textFieldLesson.text = ""
                                        self.makeAlert(titleInput: "Başarı", messageInput: "Soru başarıyla eklendi.") {
                                            // Bildirim gösterildikten sonra sayfayı kapat.
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                        
                                    }
                                })
                                
                                
                            }
                        }
                    }
                }
            }
            
        }
    }
    
}
