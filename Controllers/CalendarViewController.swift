//
//  CalendarViewController.swift
//  Move
//
//  Created by Kenny Lam on 2018-11-27.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import FSCalendar
import SnapKit

class CalendarViewController: UIViewController, UIGestureRecognizerDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDate: UILabel!
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

    private func setupUI() {
        // Getting today's date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        
        lblDate.text = formatter.string(from: currentDate).uppercased()
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.calendar.select(Date())
        self.calendar.scrollDirection = .vertical
        self.calendar.scope = .month
        self.view.addGestureRecognizer(self.scopeGesture)
        
        
        
        // Do any additional setup after loading the view.
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            self.calendarHeightConstraint.constant = bounds.height
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

    // Mark: - This allows FSCalendar to be able to update its frame
    func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }
    
    // Mark: - This allows something to be done when the data is selected this function will be added to the child view below 
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
    
    }
    



}
