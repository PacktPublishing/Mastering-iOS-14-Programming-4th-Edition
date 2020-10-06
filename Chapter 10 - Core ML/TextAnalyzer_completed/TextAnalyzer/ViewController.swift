import UIKit
import Vision
import NaturalLanguage

class ViewController: UIViewController {
  
  @IBOutlet var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.layer.cornerRadius = 6
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 1
  }
  
  @IBAction func analyze() {
    let wordCount = getWordCounts(from: textView.text)
    let model = try? SentimentPolarity(configuration: .init())

    guard let prediction = try? model?.prediction(input: wordCount) else { return }

    let alert = UIAlertController(title: nil, message: "Your text is rated: \(prediction.classLabel)", preferredStyle: .alert)
    let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
    alert.addAction(okayAction)
    present(alert, animated: true, completion: nil)
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
