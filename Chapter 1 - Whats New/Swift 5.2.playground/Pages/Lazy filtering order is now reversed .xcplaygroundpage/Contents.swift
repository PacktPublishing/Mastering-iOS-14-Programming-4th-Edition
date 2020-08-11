/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Lazy filtering order is now reversed

 */

let numbers = [1,2,3,4,5]
    .lazy
    .filter { $0 % 2 == 0 }
    .filter { print($0); return true }
_ = numbers.count

/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
