//
//  WelcomeViewController.swift
//  
//
//  
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    //Variables
    
    
    // IB Outlets
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //IB Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLetters()
       
    }
    
    // functions
    func animateLetters()
    {
        let appTitle : String = "⚡️FlashChat"
        titleLabel.text = appTitle
    }

}
