//
//  ChatViewController.swift
// 
//
//
//

import UIKit
import Firebase
import IQKeyboardManagerSwift


class ChatViewController: UIViewController {

    // variables
    let db = Firestore.firestore() // reference to our database
    let keyboardHandler = IQKeyboardManager.shared
    var messages : [Message] = []
    
    
    //IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
    //IB Actions
    @IBAction func sendPressed(_ sender: UIButton)
    {
        keyboardHandler.resignFirstResponder()
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email
        {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField:messageSender,
                K.FStore.bodyField:messageBody,
                K.FStore.dateField:Date().timeIntervalSince1970
                ])
            { (error) in
                if(error != nil)
                {
                    print(error!)
                    print("This error ocured when we were trying to send data to our database in the sendPressed function.")
                }
                else
                {
                    print("Successfully saved data.")
                }
            }
        }
        messageTextfield.text = ""
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem)
    {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
    // functions
    func loadMessages()
    {
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapShot, error) in
            self.messages.removeAll()
            if let e = error
            {
                print(e)
                print("An error occurred when loading the messages.")
            }
            else
            {
                if let snapShotDocuments = querySnapShot?.documents
                {
                    for document in snapShotDocuments
                    {
                        let data = document.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String
                        {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            // we need to remove all the elements in the array except the last one
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
}


//MARK: - UITableViewDataSource
extension ChatViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        return cell
    }
    
    
    
    
}
