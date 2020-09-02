import UIKit
import AVKit
import MediaPlayer

class AudioViewController: UIViewController {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var slider: UISlider!
  @IBOutlet var playPause: UIButton!

  let files = ["one", "two", "three"]
  var currentTrack = 0
  var audioPlayer: AVAudioPlayer!
  var timer: Timer?

  override func viewDidLoad() {
    super.viewDidLoad()

    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay])
    try? AVAudioSession.sharedInstance().setActive(true, options: [])

    NotificationCenter.default.addObserver(self, selector: #selector(updateNowPlaying), name: UIApplication.didEnterBackgroundNotification, object: nil)

    configureRemoteCommands()

    loadTrack()
  }

  func loadTrack() {
    let url = Bundle.main.url(forResource: files[currentTrack], withExtension: "mp3")!
    audioPlayer = try! AVAudioPlayer(contentsOf: url)
    audioPlayer.delegate = self
    showMetadataForURL(url)
    updateNowPlaying()
  }

  func startPlayback() {
    audioPlayer.play()
    playPause.setTitle("Pause", for: .normal)
    startTimer()
  }

  func pausePlayback() {
    audioPlayer.pause()
    playPause.setTitle("Play", for: .normal)
    stopTimer()
  }

  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
      self.slider.value = Float(self.audioPlayer.currentTime / self.audioPlayer.duration)
    }
  }

  func stopTimer() {
    timer?.invalidate()
  }

  func showMetadataForURL(_ url: URL) {
    let mediaItem = AVPlayerItem(url: url)
    let metadata = mediaItem.asset.metadata
    var information = [String]()

    for item in metadata {
      guard let identifier = item.identifier else { continue }
      switch identifier {
        case .id3MetadataTitleDescription, .id3MetadataBand:
          information.append(item.value?.description ?? "")
        default:
          break
      }
    }

    let trackTitle = information.joined(separator: " - ")
    titleLabel.text = trackTitle
  }

  func configureRemoteCommands() {
    let commandCenter = MPRemoteCommandCenter.shared()

    commandCenter.playCommand.addTarget { [unowned self] event in
      guard self.audioPlayer.isPlaying == false else { return .commandFailed }
      self.startPlayback()
      return .success
    }

    commandCenter.pauseCommand.addTarget { [unowned self] event in
      guard self.audioPlayer.isPlaying else { return .commandFailed }
      self.pausePlayback()
      return .success
    }

    commandCenter.nextTrackCommand.addTarget { [unowned self] event in
      self.nextTapped()
      return .success
    }

    commandCenter.previousTrackCommand.addTarget { [unowned self] event in
      self.previousTapped()
      return .success
    }

    UIApplication.shared.beginReceivingRemoteControlEvents()
  }


  @objc func updateNowPlaying() {
    var nowPlayingInfo = [String: Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = titleLabel.text ?? "untitled"
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }

  @IBAction func playPauseTapped() {
    if audioPlayer.isPlaying {
      pausePlayback()
    } else {
      startPlayback()
    }
  }
  
  @IBAction func nextTapped() {
    currentTrack += 1
    if currentTrack >= files.count {
      currentTrack = 0
    }
    loadTrack()
    audioPlayer.play()
  }

  @IBAction func previousTapped() {
    currentTrack -= 1
    if currentTrack < 0 {
      currentTrack = files.count - 1
    }
    loadTrack()
    audioPlayer.play()
  }

  @IBAction func sliderDragStart() {
    stopTimer()
  }

  @IBAction func sliderDragEnd() {
    startTimer()
  }

  @IBAction func sliderChanged() {
    audioPlayer.currentTime = Double(slider.value) * audioPlayer.duration
  }
}

extension AudioViewController: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    nextTapped()
  }
}
