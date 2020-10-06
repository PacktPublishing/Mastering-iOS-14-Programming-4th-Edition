import CreateML
import Foundation

let trainingData = try! MLDataTable(contentsOf: Bundle.main.url(forResource: "texts", withExtension: "json")!)
let model = try! MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "label")
try! model.write(to: URL(fileURLWithPath: "/Users/marioeguiluz/Desktop/TextClassifier.mlmodel"))

let techHeadline = try! model.prediction(from: "Snap users drop for first time, but revenue climbs")
let politicsHeadline = try! model.prediction(from: "President Donald Trump is approving a new law")
