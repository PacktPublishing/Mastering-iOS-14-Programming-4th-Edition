import Foundation

struct Question: Codable {
  let title: String
  let answerA: String
  let answerB: String
  let answerC: String
  let correctAnswer: Int
}

struct QuestionsFetchResponse: Codable {
  let questions: [Question]
}
