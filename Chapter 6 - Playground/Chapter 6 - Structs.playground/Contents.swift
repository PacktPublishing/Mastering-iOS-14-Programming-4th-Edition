import UIKit

struct Car {
    var fuelRemaining: Double
    
//    func fillFuelTank() {
//        fuelRemaining = 1
//    }
    
    mutating func fillFuelTank() {
        fuelRemaining = 1
    }

}

struct TrafficLight {
    var state: TrafficLightState
}

enum TrafficLightState: String {
    case green
    case yellow
    case red
}




