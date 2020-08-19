import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let api_key = "d9103bb7a17c9edde4471a317d298d7e"
var urlString = "https://api.themoviedb.org/3/search/movie/"
urlString = urlString.appending("?api_key=\(api_key)")
urlString = urlString.appending("&query=Swift")

let movieURL = URL(string: urlString)!

var urlRequest = URLRequest(url: movieURL)
urlRequest.httpMethod = "GET"
urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

let movieTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
  guard let data = data,
    let json = try? JSONSerialization.jsonObject(with: data, options: []),
    let jsonDict = json as? [String: AnyObject],
    let resultsArray = jsonDict["results"] as? [[String: Any]]
    else { return }

  let firstMovie = resultsArray[0]
  let movieTitle = firstMovie["title"] as! String
  print(movieTitle)
}

movieTask.resume()
