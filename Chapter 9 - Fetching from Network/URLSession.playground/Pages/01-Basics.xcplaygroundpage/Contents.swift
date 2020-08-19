import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "https://apple.com")!
let task = URLSession.shared.dataTask(with: url) {
  data, response, error in
  if let data = data {
    print(data)
  }
  if let response = response {
    print(response)
  }
  if let error = error {
    print(error)
  }
}

task.resume()

let htmlBodyTask = URLSession.shared.dataTask(with: url) { data, response, error in
  guard let data = data, error == nil
    else { return }
  
  let responseString = String(data: data, encoding: .utf8)
  print(responseString as Any)
}

htmlBodyTask.resume()
