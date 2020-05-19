import UIKit

struct Pet {
    var name: String
}

//func printName(for pet: Pet) {
//    print(pet.name)
//    pet.name = "Jesse"
//}

func printName(for pet: Pet) {
    var pet = pet
    print(pet.name)
    pet.name = "Jesse"
}


let dog = Pet(name: "Astro")
printName(for: dog)
print(dog.name)
