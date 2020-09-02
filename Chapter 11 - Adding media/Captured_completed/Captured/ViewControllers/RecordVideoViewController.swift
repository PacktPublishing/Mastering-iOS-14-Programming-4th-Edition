import UIKit
import AVFoundation

class RecordVideoViewController: UIViewController {
  @IBOutlet var videoView: UIView!
  @IBOutlet var startStopButton: UIButton!

  let videoCaptureSession = AVCaptureSession()
  let videoOutput = AVCaptureMovieFileOutput()
  var previewLayer:  AVCaptureVideoPreviewLayer?

  override func viewDidLoad() {
    super.viewDidLoad()

    // 1
    guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
    let microphone = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified) else { return }

    // 2
    do {
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      let microphoneInput = try AVCaptureDeviceInput(device: microphone)
      videoCaptureSession.addInput(cameraInput)
      videoCaptureSession.addInput(microphoneInput)
      videoCaptureSession.addOutput(videoOutput)
    } catch {
      print(error.localizedDescription)
    }

    previewLayer = AVCaptureVideoPreviewLayer(session: videoCaptureSession)
    previewLayer?.videoGravity = .resizeAspectFill
    videoView.layer.addSublayer(previewLayer!)
    videoCaptureSession.startRunning()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    previewLayer?.bounds.size = videoView.frame.size
    previewLayer?.position = CGPoint(x: videoView.frame.midX, y:videoView.frame.size.height / 2)
  }

  @IBAction func startStopRecording() {
    // 1
    if videoOutput.isRecording {
      videoOutput.stopRecording()

    } else {

      // 2
      guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
      let fileUrl = path.appendingPathComponent("recording.mov")

      // 3
      try? FileManager.default.removeItem(at: fileUrl)

      // 4
      videoOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
  }
}

extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
  // 1
  func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    startStopButton.setTitle("Stop Recording", for: .normal)
  }

  // 2
  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    guard error == nil else { return }
    UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, #selector(didSaveVideo(at:withError:contextInfo:)), nil)
  }

  // 3
  @objc func didSaveVideo(at path: String, withError error: Error?, contextInfo: UnsafeRawPointer?) {
    guard error == nil else { return }
    presentAlertWithTitle("Success", message: "Video was saved succesfully")
    startStopButton.setTitle("Start Recording", for: .normal)
  }
}
