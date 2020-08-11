/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Increase availability of implicit self in @escaping closures when reference cycles are unlikely to occur

[SE-0269](https://github.com/apple/swift-evolution/blob/master/proposals/0269-implicit-self-explicit-capture.md)
*/

/*:
 ## Case
 Now we are gonna be able to use implicit self (instead of coding it explicitly) in situations where the use is already explicit or in situations where the strong reference cycle is not possible.
*/


/*:
### Explicit use when including self into the capture list
 We can explicit self in the capture list, so we dont have to use self later in the clousure again and again:
*/

class SomeClass {
    var x = 0

    func doSomething(_ task: @escaping () -> Void) {
      task()
    }

    func test() {
      doSomething { [self] in
        x += 1 // instead of self.x += 1
        x = x * 5 // instead of self.x = self.x * 5
      }
    }
}


/*:
### When using structs :
 When using structs, the reference cycle is not possible, we can omit self
 */

struct SomeStruct {
    var x = 0

    func doSomething(_ task: @escaping () -> Void) {
      task()
    }

    func test() {
      doSomething { //note how there is no `[self] in` this time, cause SomeStruct is a Struct
        x += 1
        x = x * 5
      }
    }
}
/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
