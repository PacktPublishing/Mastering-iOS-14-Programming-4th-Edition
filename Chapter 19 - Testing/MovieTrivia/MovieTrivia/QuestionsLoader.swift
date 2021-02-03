import Foundation

typealias QuestionsLoadedCallback = ([Question]) -> Void

struct QuestionsLoader {
  let apiProvider: TriviaAPIProviding

  func loadQuestions(callback: @escaping QuestionsLoadedCallback) {
    apiProvider.loadTriviaQuestions { data in
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      guard let questionsResponse = try? decoder.decode(QuestionsFetchResponse.self, from: data)
        else { return }

      callback(questionsResponse.questions)
    }
  }
}
