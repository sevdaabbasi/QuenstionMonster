//
//  SignInViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 21.04.2024.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        signIn()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    func signIn() {
           guard let email = emailText.text, !email.isEmpty else {
               showAlert(message: "E-posta adresi boş bırakılamaz.")
               return
           }
           
           guard let password = passwordText.text, !password.isEmpty else {
               showAlert(message: "Şifre boş bırakılamaz.")
               return
           }
           
           Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
               guard let strongSelf = self else { return }
               if let error = error {
                   strongSelf.showAlert(message: error.localizedDescription)
                   return
               }
               // Giriş başarılı
               strongSelf.performSegue(withIdentifier: "TabBarSegue", sender: strongSelf)
           }
       }
    func showAlert(message: String) {
           let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
}
