import UIKit

class QuestionViewController: UIViewController {
  typealias JSON = [String: Any]
  
  var triviaJSON: JSON?
  var questions: [JSON]?
  
  @IBOutlet var questionLabel: UILabel!
  @IBOutlet var answerAButton: UIButton!
  @IBOutlet var answerBButton: UIButton!
  @IBOutlet var answerCButton: UIButton!
  @IBOutlet var resultLabel: UILabel!
  @IBOutlet var nextQuestionButton: UIButton!
  
  var currentQuestion: Int = 0
  var didSelectCorrectAnswer = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let triviaJSON = self.triviaJSON,
      let questionsArray = triviaJSON["questions"] as? [[String: Any]]
      else { return }
    
    self.questions = questionsArray
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    showCurrentQuestion()
  }
  
  func showCurrentQuestion() {
    guard let question = questions?[currentQuestion],
      let title = question["title"] as? String,
      let answerA = question["answer_a"] as? String,
      let answerB = question["answer_b"] as? String,
      let answerC = question["answer_c"] as? String
      else { return }
    
    questionLabel.text = title
    answerAButton.setTitle(answerA, for: .normal)
    answerBButton.setTitle(answerB, for: .normal)
    answerCButton.setTitle(answerC, for: .normal)
    
    didSelectCorrectAnswer = false
    resultLabel.isHidden = true
    nextQuestionButton.isHidden = true
  }
  
  @IBAction func answerButtonTapped(button: UIButton) {
    guard let question = questions?[currentQuestion],
      let correctAnswer = question["correct_answer"] as? Int,
      didSelectCorrectAnswer == false
      else { return }
    
    switch button {
    case answerAButton: didSelectCorrectAnswer = correctAnswer == 0
    case answerBButton: didSelectCorrectAnswer = correctAnswer == 1
    case answerCButton: didSelectCorrectAnswer = correctAnswer == 2
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
