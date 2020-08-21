import UIKit
import Vision
import NaturalLanguage

class ViewController: UIViewController {
  
  @IBOutlet var textView: UITextView!

  var model: SentimentPolarity?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.layer.cornerRadius = 6
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 1
  }
  
  @IBAction func analyze() {
    let wordCount = getWordCounts(from: textView.text)

    if model != nil {
      guard let prediction = try? model?.prediction(input: wordCount) else { return }
      showResult(prediction: prediction)
      return
    }

    //add code
  }

  private func showResult(prediction: SentimentPolarityOutput) {
    displayModalMessage("Your text is rated: \(prediction.classLabel)")
  }

  private func handleCollectionError(_ error: Error) {
    displayModalMessage("Error downloading the model collection")
  }

  private func handleModelLoadError(_ error: Error) {
    displayModalMessage("Error loading the model")
  }

  private func displayModalMessage(_ msg: String) {
    DispatchQueue.main.async { [self] in
      let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
      let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
      alert.addAction(okayAction)
      self.present(alert, animated: true, completion: nil)
    }
  }

  func getWordCounts(from string: String) -> [String: Double] {
    let tokenizer = NLTokenizer(unit: .word)
    tokenizer.string = string
    var wordCount = [String: Double]()

    tokenizer.enumerateTokens(in: string.startIndex..<string.endIndex) { range, attributes in
      let word = String(string[range])
      wordCount[word] = (wordCount[word] ?? 0) + 1
      return true
    }

    return wordCount
  }
}
