/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Refine didSet Semantics

[SE-0268](https://github.com/apple/swift-evolution/blob/master/proposals/0268-didset-semantics.md)
*/

/*:
 ## Case
 Introduce two changes to didSet semantics -

 If a didSet observer does not reference the oldValue in its body, then the call to fetch the oldValue will be skipped. We refer to this as a "simple" didSet.
 If we have a "simple" didSet and no willSet, then we could allow modifications to happen in-place.
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
