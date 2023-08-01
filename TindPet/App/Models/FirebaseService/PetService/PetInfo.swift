//
//  Pet Info.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import UIKit

struct PetInfo {
    var petID: String = ""
    var name: String = ""
    var age: Int = 0
    var species: Int = 0
    var ownerID: String = ""
    var photo: String?
    var image: UIImage?
}

enum Species {
    case cat, dog
}
