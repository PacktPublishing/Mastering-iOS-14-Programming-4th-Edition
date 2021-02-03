import UIKit

class QuestionViewController: UIViewController {
  var questions: [Question]?

  @IBOutlet var questionLabel: UILabel!
  @IBOutlet var answerAButton: UIButton!
  @IBOutlet var answerBButton: UIButton!
  @IBOutlet var answerCButton: UIButton!
  @IBOutlet var resultLabel: UILabel!
  @IBOutlet var nextQuestionButton: UIButton!

  var currentQuestion: Int = 0
  var didSelectCorrectAnswer = false

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    showCurrentQuestion()
  }

  func showCurrentQuestion() {
    guard let question = questions?[currentQuestion]
      else { return }

    questionLabel.text = question.title
    answerAButton.setTitle(question.answerA, for: .normal)
    answerBButton.setTitle(question.answerB, for: .normal)
    answerCButton.setTitle(question.answerC, for: .normal)

    didSelectCorrectAnswer = false
    resultLabel.isHidden = true
    nextQuestionButton.isHidden = true
  }

  @IBAction func answerButtonTapped(button: UIButton) {
    guard let question = questions?[currentQuestion],
      didSelectCorrectAnswer == false
      else { return }

    switch button {
    case answerAButton: didSelectCorrectAnswer = question.correctAnswer == 0
    case answerBButton: didSelectCorrectAnswer = question.correctAnswer == 1
    case answerCButton: didSelectCorrectAnswer = question.correctAnswer == 2
    default: return
    }

    if didSelectCorrectAnswer {
      showCorrectAnswerUI()
    } else {
      showIncorrectAnswerUI()
    }
  }

  @IBAction func nextQuestionTapped() {
    guard let questionsArray = self.questions
      else { return }

    currentQuestion += 1

    if currentQuestion >= questionsArray.count {
      currentQuestion = 0
    }

    showCurrentQuestion()
  }

  func showCorrectAnswerUI() {
    resultLabel.isHidden = false
    nextQuestionButton.isHidden = false

    resultLabel.text = "Your answer is correct!"
  }

  func showIncorrectAnswerUI() {
    resultLabel.isHidden = false
    nextQuestionButton.isHidden = true

    resultLabel.text = "Your answer is incorrect"
  }
}
