import Foundation

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
    mutating func eat(plant: Plant) {
        print("eating a \(plant.latinName)")
        plantsEaten.append(plant)
    }
}

struct Grass: PlantType {
    var latinName = "Poaceae"
}

// MARK: Generics

struct Cow<Plant: PlantType>: HerbivoreType {
    var plantsEaten: [Plant]
}

let grassCow = Cow<Grass>(plantsEaten: [Grass]())

let strings = [String]()
func simpleMap<T, U>(_ input: [T], transform: (T) -> U) -> [U] {
    
    var output = [U]()
    for item in input {
        output.append(transform(item))
    }
    
    return output
}


// Example

let result = simpleMap([1, 2, 3]) { item in
    return item * 2
}

print(result) // [2, 4, 6]
