/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Multi-Pattern Catch Clauses

[SE-0276](https://github.com/apple/swift-evolution/blob/master/proposals/0276-multi-pattern-catch-clauses.md)
*/

/*:
 ## Case
 Suppose we have a performTask() method that throws different TaskErrors and we want to catch and handle them:
*/

enum TaskError: Error {
  case someRecoverableError
  case someFailure(msg: String)
  case anotherFailure(msg: String)
}

func performTask() throws -> String {
  throw TaskError.someFailure(msg: "Some Error")
}

func recover() {}

/*:
### Before Swift 5.3:
 We need a switch statement inside a generic catch clause in order to handle multiple error cases
*/

do {
  try performTask()
} catch let error as TaskError {
  switch error {
  case TaskError.someRecoverableError:
    recover()
  case TaskError.someFailure(let msg),
       TaskError.anotherFailure(let msg):
    print(msg)
  }
}

/*:
### After Swift 5.3:
 We can handle multiple error cases in different cath clauses
 */

do {
  try performTask()
} catch TaskError.someRecoverableError {
  recover()
} catch TaskError.someFailure(let msg),
        TaskError.anotherFailure(let msg) {
  print(msg)
}

/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
