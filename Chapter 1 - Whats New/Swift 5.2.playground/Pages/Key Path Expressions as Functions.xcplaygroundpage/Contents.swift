/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)
# Key Path Expressions as Functions

[SE-0249](https://github.com/apple/swift-evolution/blob/master/proposals/0249-key-path-literal-function-expressions.md)
*/

struct Car {
    let brand: String
    let isElectric: Bool
}

let aCar = Car(brand: "Ford", isElectric: false)
let anElectricCar = Car(brand: "Tesla", isElectric: true)
let cars = [aCar, anElectricCar]

let onlyElectricCars = cars.filter { $0.isElectric }
let onlyElectricCarsAgain = cars.filter { $0[keyPath: \Car.isElectric] }

let onlyElectricCarsNewWay = cars.filter(\.isElectric)

print(onlyElectricCars)
print(onlyElectricCarsAgain)
print(onlyElectricCarsNewWay)

/*:


&nbsp;

[< Previous](@previous)           [Home](Intro)           [Next >](@next)

*/
