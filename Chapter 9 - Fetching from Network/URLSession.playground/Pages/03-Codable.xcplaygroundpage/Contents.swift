import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

struct MoviesResponse: Codable {
  let results: [Movie]
}

struct Movie: Codable {
  let id: Int
  let title: String
  let posterPath: String
  let popularity: Float
}

let api_key = "YOUR_API_KEY_HERE"
var urlString = "https://api.themoviedb.org/3/search/movie/"
urlString = urlString.appending("?api_key=\(api_key)")
urlString = urlString.appending("&query=Swift")

let movieURL = URL(string: urlString)!

var urlRequest = URLRequest(url: movieURL)
urlRequest.httpMethod = "GET"
urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

let movieTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  
  guard let data = data,
    let movies = try? decoder.decode(MoviesResponse.self, from: data)
    else { return }
  
  print(movies.results[0].posterPath)
}

movieTask.resume()
