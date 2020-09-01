import UIKit

// MARK: Protocols

protocol PetType {
    
    var name: String { get }
    var age: Int { get set }
    static var latinName: String { get }
    
    func sleep()
    
}

protocol PlantType {
    var latinName: String { get }
}

protocol Domesticatable {
    var homeAddress: String? { get }
    var hasHomeAddress: Bool { get }
}

protocol CarnivoreType {
    var favoriteMeat: String { get }
}

protocol OmnivoreType: HerbivoreType, CarnivoreType { }

protocol HerbivoreType {
    associatedtype Plant: PlantType
    var plantsEaten: [Plant] { get set }
    mutating func eat(plant: Plant)
}

extension HerbivoreType {
    typealias Plant = PlantType
    mutating func eat(plant: Plant) {
        print("eating a \(plant.latinName)")
        plantsEaten.append(plant)
    }
}

// MARK: Generics

struct Cow<Plant: PlantType>: HerbivoreType {
    var plantsEaten = [Plant]()
}

let grassCow = Cow<Grass>()
let flowerCow = Cow<Flower>()

let strings = [String]()
let strings = Array<String>()

func simpleMap<T, U>(_ input: [T], transform: (T) -> U) -> [U] {
    
    var output = [U]()
    for item in input {
        output.append(transform(item))
    }
    
    return output
}

let result = simpleMap([1, 2, 3]) { item in
    return item * 2
}

print(result) // [2, 4, 6]




// MARK: Functions

func printHomeAddress(animal: Domesticatable) {
    if let address = animal.homeAddress {
        print(address)
    }
}

func nap(pet: PetType) {
    pet.sleep()
}

func printFavoriteMeat(forAnimal animal: CarnivoreType) {
    print(animal.favoriteMeat)
}

func printFavoritePlant(forAnimal animal: HerbivoreType) {
    print(animal.favoritePlant)
}

//MARK: Structs

struct Cat: PetType {
    
    let name: String
    var age: Int
    static let latinName: String = "Felis catus"
    
    func sleep() {
        print("Cat: Zzzz")
    }
    
}

struct Dog: PetType {
    let name: String
    var age: Int
    static let latinName: String = "Canis familiaris"
    
    func sleep() {
        print("Dog: Zzzz")
    }
    
}

struct Pigeon: OmnivoreType, Domesticatable {
    var hasHomeAddress: Bool
    
    let favoriteMeat: String
    let favoritePlant: String
    let homeAddress: String?
    
    func printHomeAddress() {
        if let address = homeAddress {
            print("address: \(address.uppercased())")
        }
    }
}

let myPigeon = Pigeon(hasHomeAddress: false,
                      favoriteMeat: "Insects",
                      favoritePlant: "Seeds",
                      homeAddress: "Greater Manchester, England")
myPigeon.printHomeAddress()

func printAddress(animal: Domesticatable) {
    animal.printHomeAddress()
}
printAddress(animal: myPigeon)

struct Grass: PlantType{ var latinName = "Poaceae"
}

struct Pine: PlantType{ var latinName = "Pinus"
}

struct Cow: HerbivoreType {
    var plantsEaten = [Grass]()
}

struct Carrot: PlantType {
    let latinName = "Daucus carota"
}

struct Rabbit: HerbivoreType {
    var plantsEaten = [Carrot]()
}



var cow = Cow()
let pine = Pine()
cow.eat(plant: pine)



// MARK: Extensions
extension Domesticatable {
    func printHomeAddress() {
        if let address = homeAddress {
            print(address)
        }
    }
}

let pidgeon = Pigeon(hasHomeAddress: false,
                     favoriteMeat: "Insects",
                     favoritePlant: "Seeds",
                     homeAddress: "Greater Manchester, England")
pidgeon.printHomeAddress()

extension Domesticatable {
    var hasHomeAddress: Bool {
        return homeAddress != nil
    }
    
    func printHomeAddress() {
        if let address = homeAddress {
            print(address)
        }
    }
}



// MARK: OOP - Approach
//func sleep(pet: Pet) {
//    pet.sleep()
//}


