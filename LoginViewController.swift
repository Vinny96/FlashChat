//
//  LoginViewController.swift
//  
//
//  
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton)
    {
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error
                {
                    self.createAlert(message: e.localizedDescription)
                }
                else
                {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
    // functions
    func createAlert(message : String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
