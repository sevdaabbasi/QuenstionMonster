//
//  SignUpViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 21.04.2024.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordAgainText: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordSignUpText: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    var signUpCustomButton = CustomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomButtonConstraints()
        addActionToBottomButton()
       signUpCustomButton.setTitle("SignUp", for: .normal)
        
    }
   
    func signUp() {
           guard let email = emailTextField.text, !email.isEmpty else {
               showAlert(message: "E-posta adresi boş bırakılamaz.")
               return
           }
        
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            showAlert(message: "Kullanıcı adı boş bırakılamaz.")
            return
        }
           
           guard let password = passwordSignUpText.text, !password.isEmpty else {
               showAlert(message: "Şifre boş bırakılamaz.")
               return
           }
           
           guard let passwordAgain = passwordAgainText.text, !passwordAgain.isEmpty else {
               showAlert(message: "Şifreyi tekrar giriniz.")
               return
           }
           
           guard password == passwordAgain else {
               showAlert(message: "Şifreler eşleşmiyor.")
               return
           }
           
           Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
               guard let strongSelf = self else { return }
               if let error = error {
                   strongSelf.showAlert(message: error.localizedDescription)
                   return
               }
               // Kullanıcı başarıyla oluşturuldu, ek işlemler buraya eklenebilir.
               strongSelf.showAlert(message: "Kullanıcı başarıyla oluşturuldu.")
               
              // strongSelf.performSegue(withIdentifier: "showSignInSegue", sender: nil)
               
               
               // Kullanıcı adını Firestore'a kaydet
                  let db = Firestore.firestore()
                  let userRef = db.collection("users").document(authResult!.user.uid)
                  userRef.setData(["userName": userName]) { error in
                      if let error = error {
                          print("Kullanıcı adı Firestore'a kaydedilirken hata oluştu: \(error.localizedDescription)")
                      } else {
                          print("Kullanıcı adı başarıyla Firestore'a kaydedildi.")
                          
                          UserDefaults.standard.set(userName, forKey: "userName")
                          
                         
                      }
                  }
              }
           }
       
    
    func setupBottomButtonConstraints() {
        view.addSubview(signUpCustomButton)
       signUpCustomButton.translatesAutoresizingMaskIntoConstraints = false
       signUpCustomButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       signUpCustomButton.widthAnchor.constraint(equalToConstant: 330).isActive = true
       signUpCustomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       signUpCustomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -170).isActive = true
    }
    
    
    func addActionToBottomButton() {
        signUpCustomButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        
    }
    @objc func signUpClicked() {
        signUpCustomButton.shake()
        signUp()
       }
    
   
    @IBAction func signInClicked(_ sender: Any) {
        performSegue(withIdentifier: "SignInSegue", sender: self)
    }
    
    func showAlert(message: String) {
           let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
}
