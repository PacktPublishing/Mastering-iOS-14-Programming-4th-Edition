import Vision

let imageUrl = URL(string: "http://marioeguiluz.com/img/portfolio/Swift%20Data%20Structures%20and%20Algorithms%20Mario%20Eguiluz.jpg")!

// 1. Create a new image-request handler.
let requestHandler = VNImageRequestHandler(url: imageUrl, options: [:])


// 2. Create a new request to recognize text.
let request = VNRecognizeTextRequest { (request, error) in

  guard let observations = request.results as? [VNRecognizedTextObservation] else {
      return
  }

  let recognizedStrings = observations.compactMap { observation in
    // Return the string of the top VNRecognizedText instance.
    return observation.topCandidates(1).first?.string
  }

  // Process the recognized strings.
  print(recognizedStrings)
}

// 3. Select .accurate or .fast levels
request.recognitionLevel = .accurate

do {
  // 4. Perform the text-recognition request.
  try requestHandler.perform([request])
} catch {
  print("Unable to perform the requests: \(error).")
}


