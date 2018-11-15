//
//  SignInViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-14.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Dismissing the controller
    @IBAction func cancelSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
