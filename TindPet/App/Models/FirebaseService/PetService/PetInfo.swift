//
//  Pet Info.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation

struct PetInfo {
    var name: String
    var age: Int
    var species: Species
    var ownerID: String
//    var photo: String
}

enum Species {
    case cat, dog
}
