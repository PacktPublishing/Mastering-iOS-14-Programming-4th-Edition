import UIKit

typealias JSON = [String: Any]

class LoadTriviaViewController: UIViewController {

  var questions: [Question]?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let apiProvider = TriviaAPI()
    let questionsLoader = QuestionsLoader(apiProvider: apiProvider)
    questionsLoader.loadQuestions { [weak self] questions in
      self?.questions = questions
      self?.performSegue(withIdentifier: "TriviaLoadedSegue", sender: self)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let questionViewController = segue.destination as? QuestionViewController,
      let questions = self.questions
      else { return }

    questionViewController.questions = questions
  }
}
