/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Enum cases as protocol witnesses

[SE-0290](https://github.com/apple/swift-evolution/blob/master/proposals/0280-enum-cases-as-protocol-witnesses.md)
*/

/*:
 ## Case
 The aim of this proposal is to lift an existing restriction, which is that enum cases cannot participate in protocol witness matching. This was causing problems when conforming Enums to protocol requirements. See the following example.
*/

protocol Maximizable {
    static var maxValue: Self { get }
}

extension Int: Maximizable {
  static var maxValue: Int { Int.max }
}

/*:
### After Swift 5.3:
 Now we can do the same for Enums
 */

enum Priority: Maximizable {
    case minValue
    case someVaue(Int)
    case maxValue
}

print(Int.maxValue)
print(Priority.maxValue)
/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
