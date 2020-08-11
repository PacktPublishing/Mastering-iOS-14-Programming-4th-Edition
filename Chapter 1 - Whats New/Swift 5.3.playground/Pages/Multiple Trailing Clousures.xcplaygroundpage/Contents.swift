/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Multiple Trailing Clousures

[SE-0279](https://github.com/apple/swift-evolution/blob/master/proposals/0279-multiple-trailing-closures.md)
*/

/*:
 ## Case
 Suppose we use trailing closures with the UIView.animate UIKit method:
*/

// Without trailing closure:
UIView.animate(withDuration: 0.3, animations: {
  self.view.alpha = 0
}, completion: { _ in
  self.view.removeFromSuperview()
})

// With trailing closure syntax applied to the last clousure:
UIView.animate(withDuration: 0.3, animations: {
  self.view.alpha = 0
}) { _ in
  self.view.removeFromSuperview()
}

/*:
### Before Swift 5.3:
 If we use the method with trailing clousure, the 2nd part is hard to read and mantain, it loses the name and after some time, it can be easy to forget what is it about
*/

// With trailing closure
UIView.animate(withDuration: 0.3, animations: {
  self.view.alpha = 0
}) { _ in
  self.view.removeFromSuperview()
}

/*:
### After Swift 5.3:
 We can label multiple clousures after the initial unlabeled clousure, and we keep a better simetry in the code:
 */

// Multiple trailing closure arguments
UIView.animate(withDuration: 0.3) {
  self.view.alpha = 0
} completion: { _ in
  self.view.removeFromSuperview()
}

/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
