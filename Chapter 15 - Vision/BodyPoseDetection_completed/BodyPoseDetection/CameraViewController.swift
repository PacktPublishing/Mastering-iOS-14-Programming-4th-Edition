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

  // Vision body pose request
  private var bodyPoseRequest = VNDetectHumanBodyPoseRequest()

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


  func processPoints(_ points: [CGPoint]) {
    // TODO 4: Process and display detected points

    // Convert points from AVFoundation coordinates to UIKit coordinates.
    let previewLayer = cameraView.previewLayer
    let convertedPoints = points
      .compactMap {previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)}

    // Display converted points in the overlay
    cameraView.showPoints(convertedPoints, color: .red)
  }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // TODO 3: Perform body pose detection on the video session
    var bodyPoints: [CGPoint] = []
    defer {
      DispatchQueue.main.sync {
        self.processPoints(bodyPoints)
      }
    }

    // 2 - Use VNImageRequestHandler
    let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
    do {
      // 3 - Perform VNDetectHumanHandPoseRequest
      try handler.perform([bodyPoseRequest])

      // 4 - Continue only when a body pose was detected in the frame.
      guard let observation = bodyPoseRequest.results?.first else {
        return
      }

      var recognizedPoints:  [VNRecognizedPointKey : VNRecognizedPoint] = [:]
      recognizedPoints.merge(try observation.recognizedPoints(forGroupKey: .bodyLandmarkRegionKeyTorso) ?? [:])
      recognizedPoints.merge(try observation.recognizedPoints(forGroupKey: .bodyLandmarkRegionKeyLeftArm) ?? [:])
      recognizedPoints.merge(try observation.recognizedPoints(forGroupKey: .bodyLandmarkRegionKeyRightArm) ?? [:])

      let bodyKeys: [VNRecognizedPointKey] = [
          .bodyLandmarkKeyRightElbow,
          .bodyLandmarkKeyRightShoulder,
          .bodyLandmarkKeyRightHip,
          .bodyLandmarkKeyLeftElbow,
          .bodyLandmarkKeyLeftHip,
          .bodyLandmarkKeyLeftShoulder,
          .bodyLandmarkKeyLeftWrist,
          .bodyLandmarkKeyRightWrist
          ]

      bodyPoints = bodyKeys.compactMap {
        guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
        return CGPoint(x: point.location.x, y: 1 - point.location.y)
      }

    } catch {
      cameraFeedSession?.stopRunning()
      fatalError(error.localizedDescription)
    }
  }
}

extension Dictionary {
    mutating func merge(_ dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

