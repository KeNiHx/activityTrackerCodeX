//
//  EmailSentViewController.swift
//  Move
//
//  Created by Kenny Lam on 2018-11-21.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import Firebase

class EmailSentViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dynamicLink: URL? = nil
    

    @IBOutlet weak var lbltest: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbltest.text = appDelegate.passingLink?.absoluteString
        
        // Do any additional setup after loading the view.
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
