//
//  WorkoutOutdoorSessionViewController.swift
//  Move
//
//  Created by Lee Palisoc on 2018-11-25.
//  Copyright © 2018 CodeX. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WorkoutOutdoorSessionViewController: UIViewController {

    enum GoalType {
        case open, time, distance
    }
    
    /**
     @IBOutlets
     @brief Outlets needed for this current controller.
     */
    @IBOutlet weak var lblWorkoutType: UILabel!
    @IBOutlet weak var btnStartWorkout: UIButton!
    @IBOutlet weak var viewWorkoutDetails: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnDismissViewController: UIButton!
    @IBOutlet weak var progressBar: ProgressBarView!
    
    /**
     @IBOutlets
     @brief Outlets for the "Select Goal" popup view
     */
    @IBOutlet weak var viewSetGoals: UIView!
    @IBOutlet weak var lblSelectAGoalTitle: UILabel!
    @IBOutlet weak var btnOpenGoal: UIButton!
    @IBOutlet weak var btnTimeGoal: UIButton!
    @IBOutlet weak var btnDistanceGoal: UIButton!
    
    /**
     @IBOutlets @var
     @brief Outlets for the "Time Goal" popup view
     */
    @IBOutlet weak var viewTimeGoal: UIView!
    @IBOutlet weak var btnTimePlus: UIButton!
    @IBOutlet weak var btnTimeMinus: UIButton!
    @IBOutlet weak var btnSetTime: UIButton!
    @IBOutlet weak var lblTimeGoalHour: UILabel!
    @IBOutlet weak var lblTimeGoalMinute: UILabel!
    private var minute = 0
    private var hour = 0
    private var timeGoal: Int?
    
    /**
     @IBoutlets @var
     @brief Outlets for the "Distance Goal" popup view
     */
    @IBOutlet weak var viewDistanceGoal: UIView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnDistancePlus: UIButton!
    @IBOutlet weak var btnDistanceMinus: UIButton!
    @IBOutlet weak var btnSetDistance: UIButton!
    
    /**
     @var Variables needed for recording and saving locations.
     */
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    // Selected Goal
    private var selectedGoal: GoalType?
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showSelectGoals()
    }
    
    // MARK: - Function for setting up the UI
    private func setupUI() {
        // Adding shadows on the floating views
        viewWorkoutDetails.layer.shadowOpacity = 0.5
        viewWorkoutDetails.layer.shadowRadius = 20
        viewWorkoutDetails.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewWorkoutDetails.layer.cornerRadius = 8
    
        lblWorkoutType.layer.shadowRadius = 8
        lblWorkoutType.layer.shadowOpacity = 0.3
        lblWorkoutType.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        // Show the user's current location
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
            mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    // MARK: - Show Selecting a goal view as a pop up
    private func showSelectGoals() {
        // Hiding the @IBOutlets that are not needed yet
        viewWorkoutDetails.isHidden = true
        lblWorkoutType.isHidden = true
        viewTimeGoal.isHidden = true
        viewDistanceGoal.isHidden = true
        
        // Set the view's design
        viewSetGoals.layer.shadowOpacity = 0.5
        viewSetGoals.layer.shadowRadius = 20
        viewSetGoals.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewSetGoals.layer.cornerRadius = 12
        
        // Show the view, animated
        viewSetGoals.transform = viewSetGoals.transform.scaledBy(x: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.viewSetGoals.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
        
        // Disable everything
        mapView.isUserInteractionEnabled = false
        mapView.alpha = 0.3
    }
    
    // MARK: - Show Selecting Time Goal View as a pop up
    private func showSelectTimeGoal() {
        // Un-hide the view
        viewTimeGoal.isHidden = false
        
        // Set the view's design
        viewTimeGoal.layer.shadowOpacity = 0.5
        viewTimeGoal.layer.shadowRadius = 20
        viewTimeGoal.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewTimeGoal.layer.cornerRadius = 12
        
        // Show the view, animated
        viewTimeGoal.transform = viewSetGoals.transform.scaledBy(x: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.viewTimeGoal.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
        
        // Disable everything
        mapView.isUserInteractionEnabled = false
        mapView.alpha = 0.3
    }
    
    // MARK: - Show Selecting Distance Goal View as a pop up
    private func showSelectDistanceGoal() {
        // Un-hide the view
        viewDistanceGoal.isHidden = false
        
        // Set the view's design
        viewDistanceGoal.layer.shadowOpacity = 0.5
        viewDistanceGoal.layer.shadowRadius = 20
        viewDistanceGoal.layer.shadowOffset = CGSize(width: 1, height: 2)
        viewDistanceGoal.layer.cornerRadius = 12
        
        // Show the view, animated
        viewDistanceGoal.transform = viewSetGoals.transform.scaledBy(x: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.viewDistanceGoal.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
        
        // Disable everything
        mapView.isUserInteractionEnabled = false
        mapView.alpha = 0.3
    }
    
    // MARK: - Starting the workout
    private func startWorkout(selectedGoal: GoalType) {
        // "Clean" everything first
        locationList.removeAll()
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        
        //
    }
    
    // MARK: - Open Goal Button
    @IBAction func openGoal(_ sender: UIButton) {
        // Dismiss the Select Goal view first
        dismissSelectGoal()
        
        // Show Workout Details View
        
    }
    
    // MARK: - Time Goal Button
    @IBAction func timeGoal(_ sender: UIButton) {
        // Dismiss the Select Goal view first
        dismissSelectGoal()
        
        // Show the Time Goal view pop up
        showSelectTimeGoal()
    }
    
    // MARK: Set Time Goal: Increasing the time function for Plus button
    @IBAction func increaseTime(_ sender: UIButton) {
        minute += 1
        
        if minute > 59 {
            minute = 0
            hour += 1
            
            if hour < 10 {
                lblTimeGoalHour.text = "0" + String(hour)
            } else {
                lblTimeGoalHour.text = String(hour)
            }
        }
        if minute <= 9 {
            lblTimeGoalMinute.text = "0" + String(minute)
        }
        if minute >= 10 {
            lblTimeGoalMinute.text = String(minute)
        }
    }
    
    // MARK: - Set Time Goal: Decreasing the time function for Minus button
    @IBAction func decreaseTime(_ sender: UIButton) {
        minute -= 1
        
        if minute >= 59 {
            minute = 0
            hour -= 1
            
            if hour < 10 {
                lblTimeGoalHour.text = "0" + String(hour)
            } else {
                lblTimeGoalHour.text = String(hour)
            }
        }
        if minute <= 9 {
            lblTimeGoalMinute.text = String(minute)
        }
        if minute <= 0 {
            lblTimeGoalMinute.text = "00"
            minute = 0
        }
        if minute >= 10 {
            lblTimeGoalMinute.text = String(minute)
        }
    }
    
    // MARK: - Set Time Goal: Set the Time Goal!
    @IBAction func setTimeGoal(_ sender: UIButton) {
        // Dismiss the popup
        dismissSelectTimeGoal()
        
        // Set the time goal in time interval format
        timeGoal = (hour * 3600) + (minute * 60)
    }
    
    // MARK: - Distance Goal Button
    @IBAction func distanceGoal(_ sender: UIButton) {
        // Dismiss the Select Goal view first
        dismissSelectGoal()
        
        // Show the Distance Goal view pop up
        showSelectDistanceGoal()
    }
    
    // MARK: - Set Distance Goal: Increasing the distance funcion for Plus button
    @IBAction func increaseDistance(_ sender: UIButton) {
        
    }
    
    // MARK: - Set Distance Goal: Decreasing the distance function for Minus button
    @IBAction func decreaseDistance(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Set Distance Goal: Set the Distance Goal!
    @IBAction func btnSetDistance(_ sender: UIButton) {
        
    }
    
    
    
    // MARK: - Dismissing Select Goal View and Showing the Workout Details View
    private func dismissSelectGoal() {
        // Shrink it through animation, hide the view
        viewSetGoals.transform = viewSetGoals.transform.scaledBy(x: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.viewSetGoals.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }, completion: nil)
        
        viewSetGoals.isHidden = true
        
        // Show the Workout Details View
    }
    
    // MARK: - Dismissing Time Goal View and Showing the Workout Details View and enabling everything
    private func dismissSelectTimeGoal() {
        // Shrink it through animation, hide the view
        viewTimeGoal.transform = viewSetGoals.transform.scaledBy(x: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.viewTimeGoal.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }, completion: nil)
        
        viewTimeGoal.isHidden = true
        
        // Show the Workout Details View
    }
    
    // MARK: - Dismissing the whole view controller
    @IBAction func dismissController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Start Location Updates
    private func startLocationUpdates() {
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Location Manager Delegate
extension WorkoutOutdoorSessionViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}

// MARK: - Map View Delegate
extension WorkoutOutdoorSessionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

// LOCATION MANAGER?
class LocationManager {
    static let shared = CLLocationManager()
    
    private init() {}
}


