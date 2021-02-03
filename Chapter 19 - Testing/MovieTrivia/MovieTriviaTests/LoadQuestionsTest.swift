import XCTest
@testable import MovieTrivia

typealias JSON = [String: Any]

class LoadQuestionsTest: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func testLoadQuestions() {
    let apiProvider = MockTriviaAPI()
    let questionsLoader = QuestionsLoader(apiProvider: apiProvider)
    let questionsLoadedExpectation = expectation(description: "Expected the questions to be loaded")
    questionsLoader.loadQuestions { questions in
      guard let filename = Bundle(for: LoadQuestionsTest.self).path(forResource: "TriviaQuestions", ofType: "json"),
        let triviaString = try? String(contentsOfFile: filename),
        let triviaData = triviaString.data(using: .utf8),
        let jsonObject = try? JSONSerialization.jsonObject(with: triviaData, options: []),
        let triviaJSON = jsonObject as? JSON,
        let jsonQuestions = triviaJSON["questions"] as? [JSON]
        else { return }

      XCTAssert(questions.count > 0, "More than 0 questions should be passed to the callback")
      XCTAssert(jsonQuestions.count == questions.count, "Number of questions in json must match the number of questions in the callback.")

      questionsLoadedExpectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
  }
}
