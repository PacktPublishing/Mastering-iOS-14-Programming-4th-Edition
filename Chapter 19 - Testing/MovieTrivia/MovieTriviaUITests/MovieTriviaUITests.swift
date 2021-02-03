import XCTest

class MovieTriviaUITests: XCTestCase {

  typealias JSON = [String: Any]
  var questions: [JSON]?

  override func setUp() {
    super.setUp()

    guard let filename = Bundle(for: MovieTriviaUITests.self).path(forResource: "TriviaQuestions", ofType: "json"),
      let triviaString = try? String(contentsOfFile: filename),
      let triviaData = triviaString.data(using: .utf8),
      let jsonObject = try? JSONSerialization.jsonObject(with: triviaData, options: []),
      let triviaJSON = jsonObject as? JSON,
      let jsonQuestions = triviaJSON["questions"] as? [JSON]
      else { return }

    questions = jsonQuestions

    continueAfterFailure = false

    let app = XCUIApplication()
    app.launchArguments.append("isUITesting")
    app.launch()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testQuestionAppears() {
    let app = XCUIApplication()

    let buttonIdentifiers = ["AnswerA", "AnswerB", "AnswerC"]
    for identifier in buttonIdentifiers {
      let button = app.buttons.matching(identifier: identifier).element
      let predicate = NSPredicate(format: "exists == true")
      _ = expectation(for: predicate, evaluatedWith: button, handler: nil)
    }

    let questionTitle = app.staticTexts.matching(identifier: "QuestionTitle").element
    let predicate = NSPredicate(format: "exists == true")
    _ = expectation(for: predicate, evaluatedWith: questionTitle, handler: nil)

    waitForExpectations(timeout: 5, handler: nil)

    guard let question = questions?.first
      else { fatalError("Can't continue testing without question data...") }

    validateQuestionIsDisplayed(question)
  }

  func validateQuestionIsDisplayed(_ question: JSON) {
    let app = XCUIApplication()
    let questionTitle = app.staticTexts.matching(identifier: "QuestionTitle").element

    guard let title = question["title"] as? String,
      let answerA = question["answer_a"] as? String,
      let answerB = question["answer_b"] as? String,
      let answerC = question["answer_c"] as? String
      else { fatalError("Can't continue testing without question data...") }

    XCTAssert(questionTitle.label == title, "Expected question title to match json data")

    let buttonA = app.buttons.matching(identifier: "AnswerA").element
    XCTAssert(buttonA.label == answerA, "Expected AnswerA title to match json data")

    let buttonB = app.buttons.matching(identifier: "AnswerB").element
    XCTAssert(buttonB.label == answerB, "Expected AnswerB title to match json data")

    let buttonC = app.buttons.matching(identifier: "AnswerC").element
    XCTAssert(buttonC.label == answerC, "Expected AnswerC title to match json data")
  }

  func testAnswerValidation() {
    let app = XCUIApplication()

    let button = app.buttons.matching(identifier: "AnswerA").element
    let predicate = NSPredicate(format: "exists == true")
    _ = expectation(for: predicate, evaluatedWith: button, handler: nil)
    waitForExpectations(timeout: 5, handler: nil)

    let nextQuestionButton = app.buttons.matching(identifier: "NextQuestion").element

    guard let question = questions?.first,
      let correctAnswer = question["correct_answer"] as? Int
      else { fatalError("Can't continue testing without question data...") }

    let buttonIdentifiers = ["AnswerA", "AnswerB", "AnswerC"]
    for (i, identifier) in buttonIdentifiers.enumerated() {
      guard i != correctAnswer
        else { continue }

      app.buttons.matching(identifier: identifier).element.tap()

      XCTAssert(nextQuestionButton.exists == false, "Next question button should be hidden")
    }

    app.buttons.matching(identifier: buttonIdentifiers[correctAnswer]).element.tap()
    XCTAssert(nextQuestionButton.exists == true, "Next question button should be visible")

    nextQuestionButton.tap()

    guard let nextQuestion = questions?[1]
      else { fatalError("Can't continue testing without question data...") }

    validateQuestionIsDisplayed(nextQuestion)
    XCTAssert(nextQuestionButton.exists == false, "Next question button should be hidden")
  }
}
