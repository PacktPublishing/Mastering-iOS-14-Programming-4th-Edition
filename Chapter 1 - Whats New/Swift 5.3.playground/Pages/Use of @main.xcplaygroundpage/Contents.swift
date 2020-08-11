/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Type-Based Program Entry Points: @main

[SE-0281](https://github.com/apple/swift-evolution/blob/master/proposals/0281-main-attribute.md)
*/

/*:
 ## Case
 Up until now, when developing a swift program (like a terminal app), we needed to define the program start-up point in a main.swift file. Now we are able mark a struct or a base class (in any file) with @main and a static  func main() method on it and it will be triggered automatically when the program starts.
*/


@main
struct TerminalApp {
    static func main() {
        print("Hello Swift 5.3!")
    }
}

/*:

&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/

