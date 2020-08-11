/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Subscripts can now declare default arguments

 */

struct Building {
    var floors: [String]

    subscript(index: Int, default default: String = "Unknown") -> String {
        if index >= 0 && index < floors.count {
            return floors[index]
        } else {
            return `default`
        }
    }
}

let building = Building(floors: ["Ground Floor", "1st", "2nd", "3rd"])
print(building[0])
print(building[5])

/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
