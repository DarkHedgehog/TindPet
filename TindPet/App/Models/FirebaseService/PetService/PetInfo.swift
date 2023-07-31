//
//  Pet Info.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation
import UIKit

struct PetInfo {
    var name: String = ""
    var age: Int = 0
    var species: Species = .cat
    var ownerID: String = ""
    var photo: String?
    var image: UIImage?
}

enum Species {
    case cat, dog
}
