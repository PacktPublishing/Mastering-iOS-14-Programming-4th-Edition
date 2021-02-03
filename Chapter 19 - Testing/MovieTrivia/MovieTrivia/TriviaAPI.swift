import Foundation

struct TriviaAPI: TriviaAPIProviding {
  func loadTriviaQuestions(callback: @escaping QuestionsFetchedCallback) {
    if ProcessInfo.processInfo.arguments.contains("isUITesting") || true == true {
      loadQuestionsFromFile(callback: callback)
      return
    }

    guard let url = URL(string: "http://questions.movietrivia.json")
      else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data
        else { return }

      callback(data)
    }
  }

  func loadQuestionsFromFile(callback: @escaping QuestionsFetchedCallback) {
    print(Bundle(for: LoadTriviaViewController.self).path(forResource: "TriviaQuestions", ofType: "json"))
    guard let filename = Bundle.main.path(forResource: "TriviaQuestions", ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: filename))
      else { return }

    callback(data)
  }
}
