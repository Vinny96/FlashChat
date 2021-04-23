//
//  RegisterViewController.swift
//  
//
// 
//

import UIKit
import Firebase
import SwiftUI

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let gotError = error
                {
                    self.showAlert(message: gotError.localizedDescription)
                }
                else
                {
                    // Navigate to the chat view controller
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
    // functions
    func showAlert(message : String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  
    
}
