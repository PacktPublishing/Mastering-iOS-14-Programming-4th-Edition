import Vision

let imageUrl = URL(string: "https://marioeguiluz.com/examples/fastVision2.jpg")!
let initialDate = Date()

// 1. Create a new image-request handler.
let requestHandler = VNImageRequestHandler(url: imageUrl, options: [:])

// 2. Create a new request to recognize text.
let request = VNRecognizeTextRequest { (request, error) in

  guard let observations = request.results as? [VNRecognizedTextObservation] else {
      return
  }
  let recognizedStrings = observations.compactMap { observation in
    return observation.topCandidates(1).first?.string
  }

  print(recognizedStrings)
  if let serialNumber = recognizedStrings.first {
    let serialNumberDigits = serialNumber.map { $0.transformToDigit() }
    print(serialNumberDigits)
  }
}

// 3. Select .accurate or .fast levels
request.recognitionLevel = .fast

// 3.1 Set region of interest
request.regionOfInterest = CGRect(x: 0, y: 0.8, width: 0.3, height: 0.1)

// 4. Perform the text-recognition request.
do {
  try requestHandler.perform([request])
} catch {
  print("Unable to perform the requests: \(error).")
}

print("\(initialDate.timeIntervalSinceNow * -1) seconds")

extension Character {
  func transformToDigit() -> Character {
    let conversionTable = [
      "s": "5",
      "S": "5",
      "o": "0",
      "O": "0",
      "i": "1",
      "I": "1"
    ]
    var current = String(self)
    if let alternativeChar = conversionTable[current] {
      current = alternativeChar
    }
    return current.first!
  }
}
