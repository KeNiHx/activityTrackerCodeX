//
//  WorkoutButtonsViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-23.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit

class WorkoutButtonsViewController: UIViewController {
    
    @IBOutlet weak var btnTest: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Extension for adding designs on the UI Images
@IBDesignable extension UIButton {
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
