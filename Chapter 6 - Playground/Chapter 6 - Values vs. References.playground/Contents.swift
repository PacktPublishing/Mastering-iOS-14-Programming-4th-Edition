import UIKit

protocol PetProtocol {
    var name: String { get }
    var ownerName: String { get set }
    
}

class Animal {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Pet: Animal, PetProtocol {
    var ownerName: String
    
    init(name: String, ownerName: String) {
        self.ownerName = ownerName
        super.init(name: name)
    }
}

class ImageInformation {
    var name: String
    var width: Int
    var height: Int
    
    init(name: String, width: Int, height: Int) {
        self.name = name
        self.width = width
        self.height = height
    }
}

struct ImageLocation {
    let location: String
    let isRemote: Bool
    var isLoaded: Bool
}

let info = ImageInformation(name: "ImageName", width: 100, height: 100)
let location = ImageLocation(location: "ImageLocation", isRemote: false, isLoaded: false)


