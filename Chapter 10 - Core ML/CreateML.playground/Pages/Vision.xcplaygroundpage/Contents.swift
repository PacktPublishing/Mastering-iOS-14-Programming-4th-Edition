import CreateML
import Foundation

let dataUrl = URL(fileURLWithPath: "/path/to/trainingdata")
let source = MLImageClassifier.DataSource.labeledDirectories(at: dataUrl)
let classifier = try! MLImageClassifier(trainingData: source)

try! classifier.write(toFile: "/Users/marioeguiluz/Desktop/CarClassifier.mlmodel")
