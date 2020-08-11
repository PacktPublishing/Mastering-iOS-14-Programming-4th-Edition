/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Use of where clauses on contextually generic declarations

[SE-0267](https://github.com/apple/swift-evolution/blob/master/proposals/0267-where-on-contextually-generic.md)
*/

/*:
 ## Case
 We can use where clauses in functions with generic types and extensions
*/

struct Stack<Element> {
    private var array = [Element]()

    mutating func push(_ item: Element) {
        array.append(item)
    }

    mutating func pop() -> Element? {
        array.popLast()
    }
}

extension Stack {
    func sorted() -> [Element] where Element: Comparable {
        array.sorted()
    }
}

/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
