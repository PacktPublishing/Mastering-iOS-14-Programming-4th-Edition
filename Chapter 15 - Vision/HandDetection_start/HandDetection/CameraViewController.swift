//
//  ViewController.swift
//  HandDetection
//
//  Created by Mario Eguiluz on 09/12/2020.
//

import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController {

  // Vision hand pose request
  private var handPoseRequest = VNDetectHumanHandPoseRequest()

  // Video, view and camera feed properties
  private var cameraView: CameraView { view as! CameraView }
  private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
  private var cameraFeedSession: AVCaptureSession?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Setup video session and camera overlay
    if cameraFeedSession == nil {
      cameraView.previewLayer.videoGravity = .resizeAspectFill
      setupAVSession()
      cameraView.previewLayer.session = cameraFeedSession
    }
    cameraFeedSession?.startRunning()
  }

  override func viewWillDisappear(_ animated: Bool) {
    cameraFeedSession?.stopRunning()
    super.viewWillDisappear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO 1: Detect one hand only.

  }

  func setupAVSession() {
    // TODO 2: Create video session
  }


  func processPoints(_ fingerTips: [CGPoint?]) {
    // TODO 4: Process and display detected points
  }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // TODO 3: Perform hand detection on the video session
  }
}


