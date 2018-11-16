//
//  RegisterViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-15.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Function for making sure the texts in the description label goes to top-left and not middle when screen size goes bigger
    override func viewDidLayoutSubviews() {
        lblDescription.sizeToFit()
        
        
        /// My comment too.
    }
}
