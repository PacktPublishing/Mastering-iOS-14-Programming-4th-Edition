import UIKit

class Pet {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
func printName(for pet: Pet) {
    print(pet.name)
}
let cat = Pet(name: "Jesse")
printName(for: cat)


func printName2(for pet: Pet) {
    print(pet.name)
    pet.name = "Pugwash"
}

let dog = Pet(name: "Astro")
printName2(for: dog)
print(dog.name)

//let point = CGPoint(x: 10, y: 10)
//point.x = 10

