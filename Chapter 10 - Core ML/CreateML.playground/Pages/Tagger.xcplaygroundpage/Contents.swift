import CreateML
import NaturalLanguage

let texts = [
  "Ralph Nader again criticizes Apple’s spending, says it should raise supply chain salaries & more",
  "Police make arrest in SIM-hacking ring responsible for stolen identities & crypto",
  "What’s the best calendar app for iPhone?",
  "Comment: First impressions after nearly a month with Apple’s 2018 13-inch MacBook Pro",
  "This week’s top stories: iPhone X vs Note 9, excerpt from ex-Apple engineer’s new book, more",
  "Facebook is making two-factor a requirement for some Page managers",
  "Spotify testing new ‘Active Media’ feature that lets users skip as many ads as they want",
  "Consumers are far more excited about new iPhones than Samsung’s latest flagship, survey shows",
  "tvOS 12 beta now includes Dolby Atmos support for iTunes Movies on Apple TV",
  "New Philips Hue lights announced – some leaked before, others revealed today",
  "Taiwan FTC cancels most of Qualcomm’s fine, but it doesn’t hurt Apple’s case",
  "Security researchers take control of a brand new Mac on first Wi-Fi connection"
  ]

struct Entry: Codable {
  let tokens: [String]
  let labels: [String]
  
  init(_ string: String) {
    let tokenizer = NLTokenizer(unit: .word)
    tokenizer.string = string
    
    var tokens = [String]()
    var labels = [String]()
    tokenizer.enumerateTokens(in: string.startIndex..<string.endIndex) { range, _ in
      labels.append("NONE")
      tokens.append(String(string[range]))
      
      return true
    }
    
    self.tokens = tokens
    self.labels = labels
  }
}

let entries = texts.map(Entry.init)
let encoder = JSONEncoder()
let output = try! encoder.encode(entries)

let labelTrainingData = try! MLDataTable(contentsOf: Bundle.main.url(forResource: "labels", withExtension: "json")!)
let model = try! MLWordTagger(trainingData: labelTrainingData, tokenColumn: "tokens", labelColumn: "labels")
try! model.write(to: URL(fileURLWithPath: "/Users/marioeguiluz/Desktop/TextTagger.mlmodel"))

let taggedResult = try! model.prediction(from: "Apple and Samsung call Facebook to discuss new iPhone TV app")
print(taggedResult)
