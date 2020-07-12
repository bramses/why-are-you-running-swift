//
//  ViewController.swift
//  why-are-you-running
//
//  Created by Macbook Pro on 5/23/20.
//  Copyright © 2020 Bram. All rights reserved.
//

import UIKit
import RealityKit
import CoreMotion
import Foundation
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    var isRunning = false
    var mask: Running.Scene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        mask = try! Running.loadScene()
        
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(mask)
        arView.session.run(configuration)
        
        startTrackingActivityType()
    }
    
    
    private func startTrackingActivityType() {
      activityManager.startActivityUpdates(to: OperationQueue.main) {
          [weak self] (activity: CMMotionActivity?) in

          guard let activity = activity else { return }
          DispatchQueue.main.async {
              if activity.walking {
                  self?.isRunning = false
                  print("Walking")
              } else if activity.stationary {
                  self?.isRunning = false
                  print("Stationary")
              } else if activity.running {
                  self?.isRunning = true
                  self?.mask.notifications.fast.post()
                  print("Running")
              } else if activity.automotive {
                  self?.isRunning = false

                  print("Automotive")
              }
          }
      }
    }
}
