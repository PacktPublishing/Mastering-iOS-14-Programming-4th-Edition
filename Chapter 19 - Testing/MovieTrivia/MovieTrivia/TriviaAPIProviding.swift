import Foundation

typealias QuestionsFetchedCallback = (Data) -> Void

protocol TriviaAPIProviding {
  func loadTriviaQuestions(callback: @escaping QuestionsFetchedCallback)
}
