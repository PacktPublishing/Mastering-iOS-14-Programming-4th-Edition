import UIKit

class LoadTriviaViewController: UIViewController {
  
  typealias JSON = [String: Any]
  
  var triviaJSON: JSON?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    /*
     * Uncomment to test game with json data
     *
     guard let filename = Bundle.main.path(forResource: "TriviaQuestions", ofType: "json"),
     let triviaString = try? String(contentsOfFile: filename),
     let triviaData = triviaString.data(using: .utf8),
     let jsonObject = try? JSONSerialization.jsonObject(with: triviaData, options: []),
     let triviaJSON = jsonObject as? JSON
     else { return }
     
     self.triviaJSON = triviaJSON
     performSegue(withIdentifier: "TriviaLoadedSegue", sender: self)
     */
    
    /*
     * Won't work since the url provided is fake. Mostly intended to illustrate
     * how this would work in a real world scenario
     */
    guard let url = URL(string: "http://quesions.movietrivia.json")
      else { return }
    
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let data = data,
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
        let json = jsonObject as? JSON
        else { return }
      
      self?.triviaJSON = json
      self?.performSegue(withIdentifier: "TriviaLoadedSegue", sender: self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let questionViewController = segue.destination as? QuestionViewController,
      let triviaJSON = self.triviaJSON
      else { return }
    
    questionViewController.triviaJSON = triviaJSON
  }
}
