//
//  ViewController.swift
//  MotionMonitor
//
//  Created by Steve D'Amico on 4/25/16.
//  Copyright © 2016 Steve D'Amico. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet var gyroscopeLabel: UILabel!
    @IBOutlet var accelerometerLabel: UILabel!
    @IBOutlet var attitudeLabel: UILabel!
    
    /* Develops an instance of CMMotionManager and an operation queue */
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Request device motion updates and update the labels with the gyroscope, accelerometer, and attitude */
        
        if motionManager.deviceMotionAvailable {            // Device available and equipped?
            motionManager.deviceMotionUpdateInterval = 0.1  // Update rate
            motionManager.startDeviceMotionUpdatesToQueue(queue) {
            
            // Closure defines the work with each update and the queue closure will be executed in
                    (motion:CMDeviceMotion?, error:NSError?) -> Void in
                if let motion = motion {
                    
            // Simple rotation rate structure passed from CMDeviceMotion
                    let rotationRate = motion.rotationRate
                    let gravity = motion.gravity
                    let userAcc = motion.userAcceleration
                    let attitude = motion.attitude
                    
            // Gyroscope values are passed through rotationRate property of the CMDeviceMotion
                    let gyroscopeText = String(format: "Rotation Rate:\n-----------------\n" + "x: %+.2f\ny: %+.2f\nz: %+.2f\n", rotationRate.x, rotationRate.y, rotationRate.z)
            
            // Accelerometer data includes gravity force and user applied forces
                    let acceleratorText = String(format: "Acceleration:\n---------------\n" + "Gravity x: %+.2f\t\tUser x: %+.2f\n" + "Gravity y: %+.2f\t\tUser y: %+.2f\n" + "Gravity z: %+2f\t\tUser z: %+.2f\n", gravity.x, userAcc.x, gravity.y, userAcc.y, gravity.z, userAcc.z)
                    
            // Attitude is reported in the attitude property a type of CMAttitude
                    let attitudeText = String(format: "Attitude:\n----------\n" + "Roll: %+.2f\nPitch: %+.2f\nYaw: %+.2f\n", attitude.roll, attitude.pitch, attitude.yaw)
           
            /* Excution is from within NSOperationQueue requiring dispatch_async() function to pass control to the labels' text */
                    dispatch_async(dispatch_get_main_queue()) {
                        self.gyroscopeLabel.text = gyroscopeText
                        self.accelerometerLabel.text = acceleratorText
                        self.attitudeLabel.text = attitudeText
                    }
                }
            }
        }
    }

}

