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
import CoreMotion

class WorkoutOutdoorSessionViewController: UIViewController {
    
    /**
     @IBOutlets
     @brief Outlets needed for this current controller.
     */
    @IBOutlet weak var lblWorkoutType: UILabel!
    @IBOutlet weak var btnStartWorkout: UIButton!
    @IBOutlet weak var viewWorkoutDetails: UIView!
    @IBOutlet weak var btnDismissViewController: UIButton!
    @IBOutlet weak var progressBar: ProgressBarView!
    @IBOutlet weak var lblTitleProgress: UILabel!
    @IBOutlet weak var lblProgressPercentage: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lblTimerHour: UILabel!
    @IBOutlet weak var lblTimerMinute: UILabel!
    @IBOutlet weak var lblTimerSecond: UILabel!
    @IBOutlet weak var lblDistanceElapsed: UILabel!
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblTotalCalories: UILabel!
    
    private var totalSteps: Int = 0
    var chosenWorkout: WorkoutType?
    var color: UIColor?
    enum SessionState { case running, paused, notRunning }
    var sessionState: SessionState = .notRunning
    
    /**
     @CoreMotion
     @brief instances needed for pedometer
    */
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    /**
     @IBOutlets @enum
     @brief Outlets for the "Select Goal" popup view
     */
    @IBOutlet weak var viewSetGoals: UIView!
    @IBOutlet weak var lblSelectAGoalTitle: UILabel!
    @IBOutlet weak var btnOpenGoal: UIButton!
    @IBOutlet weak var btnTimeGoal: UIButton!
    @IBOutlet weak var btnDistanceGoal: UIButton!
    
    enum GoalType {
        case open, time, distance
    }
    
    /**
     @IBOutlets @var
     @brief Outlets for the "Time Goal" popup view
     */
    @IBOutlet weak var viewTimeGoal: UIView!
    @IBOutlet weak var lblSetTime: UILabel!
    @IBOutlet weak var btnTimePlus: UIButton!
    @IBOutlet weak var btnTimeMinus: UIButton!
    @IBOutlet weak var btnChangeTime: UIButton!
    @IBOutlet weak var btnSetTime: UIButton!
    @IBOutlet weak var lblTimeGoalHour: UILabel!
    @IBOutlet weak var lblTimeGoalMinute: UILabel!
    
    private var timeGoal: Int?
    
    /**
     @IBoutlets @var
     @brief Outlets for the "Distance Goal" popup view
     */
    @IBOutlet weak var viewDistanceGoal: UIView!
    @IBOutlet weak var lblSetDistance: UILabel!
    @IBOutlet weak var btnDistancePlus: UIButton!
    @IBOutlet weak var btnDistanceMinus: UIButton!
    @IBOutlet weak var btnChangeDistance: UIButton!
    @IBOutlet weak var btnSetDistance: UIButton!
    @IBOutlet weak var lblDistance: UILabel!
    
    private var distanceGoal: Double = 0.0
    
    /**
     @var Variables needed for recording and saving locations.
     */
    private let locationManager = LocationManager.shared
    private var timer = Timer()
    private var timeElapsed: TimeInterval = 0.0
    private var minute = 0
    private var hour = 0
    private var second = 0
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    // Selected Goal
    private var selectedGoal: GoalType?
    
    var progress = 0.01
    var percent = 0.01
    
    /**
     @UIViews
     @brief Goal popup views
    */
    @IBOutlet weak var viewHalfGoal: UIView!
    
    
    // MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapViewConstrainsts()
        showSelectGoals()
    }
    
    // Overriding built-in function: viewWillAppear, viewWillDisappear
    // This helps when the controller gets accidentally dismissed by the user, the controller "restarts" its initial setup
    override func viewWillAppear(_ animated: Bool) {
        // Hides other popups
        viewTimeGoal.isHidden = true
        viewDistanceGoal.isHidden = true
        
        // Show the first popup
        showSelectGoals()
    }
    
    // This resets everything when the view disappears
    override func viewWillDisappear(_ animated: Bool) {
        timeElapsed = 0.0
        minute = 0
        hour = 0
        second = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        distanceGoal = 0.0
        timeGoal = 0
        sessionState = .notRunning
    }
    
    // MARK: - Show Selecting a goal view as a pop up
    private func showSelectGoals() {
        // Set up the view's design, animated
        setupView(vc: viewSetGoals)
        
        // Disable everything
        disableEverythingTemporarily()
    }
    
    // MARK: - Show Selecting Time Goal View as a pop up
    private func showSelectTimeGoal() {
        // Un-hide the previous view, initially disable the minus button and set button since everything is zero.
        viewTimeGoal.isHidden = false
        btnTimeMinus.isEnabled = false
        btnSetTime.isEnabled = false
        btnSetTime.alpha = 0.5
        
        // Set the view's design
        setupView(vc: viewTimeGoal)
    }
    
    // MARK: - Show Selecting Distance Goal View as a pop up
    private func showSelectDistanceGoal() {
        // Un-hide the previous view, initially disable the minus button since everything is zero.
        viewDistanceGoal.isHidden = false
        btnDistanceMinus.isEnabled = false
        btnSetDistance.isEnabled = false
        btnSetDistance.alpha = 0.5
        
        // Set the view's design
        setupView(vc: viewDistanceGoal)
    
    }
    
    // MARK: - Start the session using the "Play" button
    @IBAction func startSession(_ sender: UIButton) {
        // Setting the button's states
        switch sessionState {
            // If the state is currently running, when this function executes, the state should go to "Pause", replace the button to "Resume", pause tracking
            case .running:
                btnStartWorkout.setBackgroundImage(UIImage(named: "Button_Resume") as UIImage?, for: .normal)
                // PAUSE TRACKING
                pauseTracking()
            
            // If the state is currently paused, change the button to "Resume" for resume
            case .paused:
                btnStartWorkout.setBackgroundImage(UIImage(named: "Button_Pause") as UIImage?, for: .normal)
                // RESUME TRACKING
                resumeTracking()
            
            // The default state it not running. Therefore, this starts the workout, changes the button to "Pause", and start tracking
            case .notRunning:
                btnStartWorkout.setBackgroundImage(UIImage(named: "Button_Pause") as UIImage?, for: .normal)
                startTracking()
        }
    }
    
    // MARK: - Start tracking: location, time elapsed, distance, steps
    private func startTracking() {
        // "Clean" everything first
        mapView.removeOverlays(mapView.overlays)
        locationList.removeAll()
        distance = Measurement(value: 0, unit: UnitLength.meters)
        
        // Set session state
        sessionState = .running
        
        // Start the timer
        startTimer()
        
        // Start getting and updating the location
        startLocationUpdates()
        
        // Start tracking steps
        if CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isPaceAvailable() {
            
            // Start tracking
            pedometer.startUpdates(from: Date()) {
                [weak self] moveData, error in guard let moveData = moveData, error == nil else { return }
                
                DispatchQueue.main.async {
                    self?.totalSteps = moveData.numberOfSteps as! Int
                    self!.lblTotalSteps.text = String(self!.totalSteps)
                    
                    self!.lblTotalCalories.text = String(format: "%.0f", (self?.calculateCalories(steps: self!.totalSteps))!)
                }
            }
        }
        else {
            let alertDenied = UIAlertController(title: "Motion Access Required", message: "This app has been denied to read any motion activities on this device. Go to your Settings to enable it.", preferredStyle: .alert)
            
            let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
            }
            alertDenied.addAction(goToSettings)
            alertDenied.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            switch CMMotionActivityManager.authorizationStatus() {
                case CMAuthorizationStatus.denied:
                    self.present(alertDenied, animated: true)
                default:
                    break
            }
        }
    }
    
    // MARK: - Pause tracking: location, timer, distance, steps
    private func pauseTracking() {
        sessionState = .paused
        
        timer.invalidate()
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
        
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Resume tracking: location, timer, distance, steps
    private func resumeTracking() {
        sessionState = .running
    
        startTimer()
        
        activityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: {_ in
        })
        
        pedometer.startUpdates(from: Date()) {
            [weak self] moveData, error in guard let moveData = moveData, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.totalSteps = moveData.numberOfSteps as! Int
                self!.lblTotalSteps.text = String(self!.totalSteps)
            }
        }
        
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Starting timer
    private func startTimer() {
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: - Updating the timer
    @objc private func updateTimer() {
        timeElapsed += 1
        formatTime(interval: timeElapsed)
        updateInformation()
        checkProgress()
    }
    
    // MARK: - Formatting the time
    private func formatTime(interval: TimeInterval) {
        var seconds = Int(interval + 0.5) //round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        
        lblTimerHour.text = String(format: "%02i", hours)
        lblTimerMinute.text = String(format: "%02i", minutes)
        lblTimerSecond.text = String(format: "%02i", seconds)
    }
    
    // MARK: - Updating the information for every second
    private func updateInformation() {
        lblDistanceElapsed.text = String(format: "%.2f", distance.value / 1000)
    }
    
    // MARK: - Open Goal Button
    @IBAction func openGoal(_ sender: UIButton) {
        // Dismiss the Select Goal view first
        dismissSelectGoal()
        
        // Selecting the goal type
        selectedGoal = GoalType.open
        
        // Show Workout Details View
        showWorkoutDetailsView()
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
        btnTimeMinus.isEnabled = true
        btnSetTime.isEnabled = true
        btnSetTime.alpha = 1.0
        
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
            lblTimeGoalMinute.text = "0" + String(minute)
        }
        if minute <= 0 {
            lblTimeGoalMinute.text = "00"
            
            if hour < 1 {
                hour = 0
                minute = 0
                btnTimeMinus.isEnabled = false
                btnSetTime.isEnabled = false
                btnSetTime.alpha = 0.5
            } else {
                hour -= 1
                minute = 00
                lblTimeGoalHour.text = "00"
            }
        }
        if minute >= 10 {
            lblTimeGoalMinute.text = String(minute)
        }
    }
    
    // MARK: - Set Time Goal: Set the Time Goal!
    @IBAction func setTimeGoal(_ sender: UIButton) {
        // Dismiss the popup, show the workout details view
        dismissSelectTimeGoal()
        showWorkoutDetailsView()
        
        // Setting the goal type
        selectedGoal = GoalType.time
        
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
        distanceGoal += 0.1
        lblDistance.text = String(format: "%.1f", distanceGoal)
        
        // Enables the minus button
        btnDistanceMinus.isEnabled = true
        btnSetDistance.isEnabled = true
        btnSetDistance.alpha = 1.0
    }
    
    // MARK: - Set Distance Goal: Decreasing the distance function for Minus button
    @IBAction func decreaseDistance(_ sender: UIButton) {
        distanceGoal -= 0.1
        
        if distanceGoal < 0 {
            distanceGoal = 0.0
            btnDistanceMinus.isEnabled = false
            btnSetDistance.isEnabled = false
            btnSetDistance.alpha = 0.5
            lblDistance.text = String(format: "%.1f", distanceGoal)
        } else {
            lblDistance.text = String(format: "%.1f", distanceGoal)
        }
    }
    
    // MARK: - Set Distance Goal: Set the Distance Goal!
    @IBAction func btnSetDistance(_ sender: UIButton) {
        // Dismiss the view pop since the Distance Goal is already set using @var distanceGoal, and show the workout details view
        dismissSelectDistanceGoal()
        showWorkoutDetailsView()
        
        // Setting the goal type
        selectedGoal = GoalType.distance
    }
    
    // MARK: - Dismissing Select Goal View and Showing the Workout Details View
    private func dismissSelectGoal() {
        // Shrink it through animation, hide the view
        viewSetGoals.transform = viewSetGoals.transform.scaledBy(x: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.viewSetGoals.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }, completion: nil)
        
        viewSetGoals.isHidden = true
    }
    
    // MARK: - Dismissing Time Goal View and Showing the Workout Details View and enabling everything
    private func dismissSelectTimeGoal() {
        // Shrink it through animation, hide the view
        viewTimeGoal.transform = viewSetGoals.transform.scaledBy(x: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.viewTimeGoal.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }, completion: nil)
        
        viewTimeGoal.isHidden = true
    }
    
    // MARK: - Dismissing Distance Goal View and Showing the Workout Details View and enabling everything
    private func dismissSelectDistanceGoal() {
        // Shrink it through animation, hide the view
        viewDistanceGoal.transform = viewSetGoals.transform.scaledBy(x: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.viewDistanceGoal.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }, completion: nil)
        
        viewDistanceGoal.isHidden = true
    }
    
    // MARK: - Go back from Time Goal to Select Goal
    @IBAction func changeTimeGoal(_ sender: UIButton) {
        dismissSelectTimeGoal()
        showSelectGoals()
    }
    
    // MARK: - Go back from Distance Goal to Select Goal
    @IBAction func changeDistanceGoal(_ sender: UIButton) {
        dismissSelectDistanceGoal()
        showSelectGoals()
    }
    
    // MARK: - Dismissing the whole view controller
    @IBAction func dismissController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Show the Working Details View, as well as the user's current location
    private func showWorkoutDetailsView() {
        // Enable the map's view and its interaction
        mapView.alpha = 1.0
        mapView.isUserInteractionEnabled = true
        
        // Start to show the user's current location
        showUserLocation()
        
        // Set the workout type chosen by the user
        switch chosenWorkout {
            case .outdoorRunning?:
                lblWorkoutType.text = "Running"
            case .outdoorWalking?:
                lblWorkoutType.text = "Walking"
            case .outdoorCycling?:
                lblWorkoutType.text = "Cycling"
            default:
                print("Something went wrong.")
        }
        
        // Adding shadows and animations on the workout type label
        lblWorkoutType.layer.shadowRadius = 8
        lblWorkoutType.layer.shadowOpacity = 0.4
        lblWorkoutType.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        // Animation
        lblWorkoutType.transform = lblWorkoutType.transform.scaledBy(x: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.lblWorkoutType.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
        
        setupView(vc: viewWorkoutDetails)
        
        // Show the workout details view
        lblWorkoutType.isHidden = false
        
        // Show the progress bar ONLY when the goal type selected is either Time or Distance
        switch selectedGoal {
            case .open?:
                lblTitleProgress.isHidden = true
                lblProgressPercentage.isHidden = true
                progressBar.isHidden = true
            default:
                lblTitleProgress.isHidden = false
                lblProgressPercentage.isHidden = false
                progressBar.isHidden = false
        }
    }
    
    // MARK: - Show the map view
    private func setMapViewConstrainsts() {
        // Setting the contrainsts
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - Start Location Updates
    private func startLocationUpdates() {
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 8
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Show the user's current location, animated with follow
    private func showUserLocation() {
        // Show the user's current location
        locationManager.requestWhenInUseAuthorization()
        
        // Check if the privacy information is enabled.
        // If it's disabled or the app didn't any permission, it will display and alert informing the user about it and giving the user the option to open the settings directly from the alert
        if CLLocationManager.locationServicesEnabled() {
            mapView.delegate = self
            
            let userLocation = CLLocationManager()
            
            userLocation.delegate = self as CLLocationManagerDelegate
            userLocation.desiredAccuracy = kCLLocationAccuracyBest
            userLocation.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
            
            if let coor = mapView.userLocation.location?.coordinate {
                let viewRegion = MKCoordinateRegion(center: coor, latitudinalMeters: 200, longitudinalMeters: 200)
                mapView.setRegion(viewRegion, animated: false)
            }
            
        } else {
            let locationDisabledAlert = UIAlertController(title: "Location Services is Disabled", message: "Outdoor workouts need your permission to display and record location data. Go to your settings to enable it.", preferredStyle: .alert)
            
            let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel)
            
            locationDisabledAlert.addAction(cancelAlert)
            locationDisabledAlert.addAction(goToSettings)
            
            self.present(locationDisabledAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Check the user's current progress
    private func checkProgress() {
        switch selectedGoal {
            case .distance?:
                let currentProgressInDistance = distance / distanceGoal
                progressBar.progress = CGFloat(currentProgressInDistance.value)
                lblProgressPercentage.text = String(Int(currentProgressInDistance.value * 100)) + "%"
            case .time?:
                let currentProgressInTime = Double(timeElapsed) / Double(timeGoal!)
                progressBar.progress = CGFloat(currentProgressInTime)
                lblProgressPercentage.text = String(Int(currentProgressInTime*100)) + "%"
            
                if Int(currentProgressInTime*100) == 50 {
                    setupView(vc: viewHalfGoal)
                }
            case .open?:
                print("")
            case .none:
                print(" ")
        }
    }
    
    private func calculateCalories(steps: Int) -> Double {
        let burned = Double(steps) * 0.05
        
        if steps < 0 {
            print("ERROR: A step can't be negative.")
            return 0
        }
        if burned > 10000 {
            print("ERROR: Maximum calorie burned should be below or equal to 10,000.")
            return 10000
        }
        else {
            return burned
        }
    }
    
    // MARK: Set up the view's design, unhide it, and do its animation
    private func setupView(vc: UIView) {
        // Unhide
        vc.isHidden = false
        
        // Animation
        vc.transform = vc.transform.scaledBy(x: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            vc.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
        
        // Design
        vc.layer.shadowOpacity = 0.4
        vc.layer.shadowRadius = 20
        vc.layer.shadowOffset = CGSize(width: 1, height: 2)
        vc.layer.cornerRadius = 12
        
        // Setting the colors for everything
        // Select A Goal
        lblSelectAGoalTitle.backgroundColor = color
        btnOpenGoal.backgroundColor = color
        btnTimeGoal.backgroundColor = color
        btnDistanceGoal.backgroundColor = color
        
        // Select Time Goal
        lblSetTime.backgroundColor = color
        btnChangeTime.backgroundColor = color
        btnSetTime.backgroundColor = color
        
        // Select Distance Goal
        lblSetDistance.backgroundColor = color
        btnChangeDistance.backgroundColor = color
        btnSetDistance.backgroundColor = color
    }
    
    // MARK: Disabling everything temporarily to give the attention to the current view
    private func disableEverythingTemporarily() {
        // Disable the map view's interactivity
        mapView.alpha = 0.5
        mapView.isUserInteractionEnabled = false
        lblWorkoutType.isHidden = true
        viewWorkoutDetails.isHidden = true
        viewTimeGoal.isHidden = true
        viewDistanceGoal.isHidden = true
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
        renderer.strokeColor = color
        renderer.lineWidth = 3
        return renderer
    }
}


