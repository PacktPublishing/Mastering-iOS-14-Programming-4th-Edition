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
}

// 3. Select .accurate or .fast levels
request.recognitionLevel = .accurate

// 4. Perform the text-recognition request.
do {
  try requestHandler.perform([request])
} catch {
  print("Unable to perform the requests: \(error).")
}

print("\(initialDate.timeIntervalSinceNow * -1) seconds")
