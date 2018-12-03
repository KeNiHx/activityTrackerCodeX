//
//  CalendarChartChildViewController.swift
//  Move
//
//  Created by Kenny Lam on 2018-11-29.
//  Copyright © 2018 CodeX. All rights reserved.
//


import FSCalendar
import SnapKit
import UIKit
import FirebaseDatabase
import FirebaseAuth


class CalendarChartChildViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var ref: DatabaseReference?
    var handle: AuthStateDidChangeListenerHandle?
    var databaseHandle: DatabaseHandle?
    var postData = [String]()
    
    let list = ["milk", "honey", "bread", "tacos", "tomatoes" ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default,reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return(cell)
    }
    
    private func setupUI() {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        ref = Database.database().reference()
     

        // Mark: -This will retrieve posts and listen for changes
//        ref?.child("users").observe(.value, with: { (DataSnapshot) in
//            //Try to convert the value of the data to a string
//            let post = DataSnapshot.value as? String
//            if let actualPost = post {
//
//            // Append the data to our postData array
//            self.postData.append(actualPost)
//
//
//            }
//        })
        
        //Mark: -This will retrieve data from the database
        let userID = Auth.auth().currentUser?.uid
        ref?.child("user").child(userID!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
            // Get user value
            let value = DataSnapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            //more values like date, cal, distance etc.
            print(username)
            
            
        }) { (error) in
            print(error.localizedDescription)
        
    }
    
   
    // FIREBASE
    // MARK: Adding Firebase's Authentications
    // The controller's viewWillAppear
        func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    // The controller's viewWillDisappear
        func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    
    
    // Mark: - This allows something to be done when the data is selected this function will be added to the child view below
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        
    }

}
}
