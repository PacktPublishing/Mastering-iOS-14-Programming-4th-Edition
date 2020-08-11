/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Synthesized Comparable conformance for enum types

[SE-0266](https://github.com/apple/swift-evolution/blob/master/proposals/0266-synthesized-comparable-for-enumerations.md)
*/

/*:
 ## Case
 enum types with no associated values or with only Comparable associated values are now elegible for synthetized conformances. This means that Swift will be able to compare their values without us writting the Comparable mehods. The order goes from top to bottom of the declaration of the enum cases, being the top the smallest value. Lets it with some examples.
*/

/*:
### Before Swift 5.3:
 We need to implement Comparable and is hard to mantain as we add more cases in the future
*/

enum Volume: Comparable {
    case low
    case medium
    case high

    private static func minimum(_ lhs: Self, _ rhs: Self) -> Self {
        switch (lhs, rhs) {
        case (.low,    _), (_, .low   ):
            return .low
        case (.medium, _), (_, .medium):
            return .medium
        case (.high,   _), (_, .high  ):
            return .high
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        return (lhs != rhs) && (lhs == Self.minimum(lhs, rhs))
    }
}


/*:
### After Swift 5.3:
 Comparable is synthetized for us. We can sort the array without further implementation of Comparable for the values of the enum.
 */

enum Size: Comparable {
  case small(Int)
  case medium
  case large(Int)
}

let sizes: [Size] = [.medium, .small(1), .small(2), .large(0)]
print(sizes.sorted())
//[.small(1), .small(2), .medium, .large(0)]

/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
