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
    handPoseRequest.maximumHandCount = 1
  }

  func setupAVSession() {
    // TODO 2: Create video session

    // 1 - Front camera as input
    guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
      fatalError("No front camera.")
    }
    // 2- Capture input from the camera
    guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
      fatalError("No video device input.")
    }

    let session = AVCaptureSession()
    session.beginConfiguration()
    session.sessionPreset = AVCaptureSession.Preset.high

    // Add video input to session
    guard session.canAddInput(deviceInput) else {
      fatalError("Could not add video device input to the session")
    }
    session.addInput(deviceInput)

    let dataOutput = AVCaptureVideoDataOutput()
    if session.canAddOutput(dataOutput) {
      session.addOutput(dataOutput)
      // Add a video data output.
      dataOutput.alwaysDiscardsLateVideoFrames = true
      dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
      dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
    } else {
      fatalError("Could not add video data output to the session")
    }
    session.commitConfiguration()
    cameraFeedSession = session
  }


  func processPoints(_ fingerTips: [CGPoint?]) {
    // TODO 4: Process and display detected points

    // Convert points from AVFoundation coordinates to UIKit coordinates.
    let previewLayer = cameraView.previewLayer
    let convertedPoints = fingerTips
      .compactMap {$0}
      .compactMap {previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)}

    // Display converted points in the overlay
    cameraView.showPoints(convertedPoints, color: .red)
  }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // TODO 3: Perform hand detection on the video session

    // 1 - We want to detect the TIP of the four fingers and the thumb
    var thumbTip: CGPoint?
    var indexTip: CGPoint?
    var ringTip: CGPoint?
    var middleTip: CGPoint?
    var littleTip: CGPoint?

    defer {
      DispatchQueue.main.sync {
        self.processPoints([thumbTip, indexTip, ringTip, middleTip, littleTip])
      }
    }

    // 2 - Use VNImageRequestHandler
    let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
    do {
      // 3 - Perform VNDetectHumanHandPoseRequest
      try handler.perform([handPoseRequest])

      // 4 - Continue only when a hand was detected in the frame.
      guard let observation = handPoseRequest.results?.first else {
        return
      }

      // 5 - Get observation points for thumb and four finger.
      let thumbPoints = try observation.recognizedPoints(.thumb)
      let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
      let ringFingerPoints = try observation.recognizedPoints(.ringFinger)
      let middleFingerPoints = try observation.recognizedPoints(.middleFinger)
      let littleFingerPoints = try observation.recognizedPoints(.littleFinger)

      // 6 - Ensure that we obtain the TIP for each finger and thumb
      guard let littleTipPoint = littleFingerPoints[.littleTip], let middleTipPoint = middleFingerPoints[.middleTip], let ringTipPoint = ringFingerPoints[.ringTip], let indexTipPoint = indexFingerPoints[.indexTip], let thumbTipPoint = thumbPoints[.thumbTip] else {
        return
      }

      // 7 - Convert points from Vision coordinates to AVFoundation coordinates.
      thumbTip = CGPoint(x: thumbTipPoint.location.x, y: 1 - thumbTipPoint.location.y)
      indexTip = CGPoint(x: indexTipPoint.location.x, y: 1 - indexTipPoint.location.y)
      ringTip = CGPoint(x: ringTipPoint.location.x, y: 1 - ringTipPoint.location.y)
      middleTip = CGPoint(x: middleTipPoint.location.x, y: 1 - middleTipPoint.location.y)
      littleTip = CGPoint(x: littleTipPoint.location.x, y: 1 - littleTipPoint.location.y)

    } catch {
      cameraFeedSession?.stopRunning()
      fatalError(error.localizedDescription)
    }
  }
}


