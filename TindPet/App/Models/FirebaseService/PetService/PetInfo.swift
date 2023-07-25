//
//  Pet Info.swift
//  TindPet
//
//  Created by Asya Checkanar on 23.07.2023.
//

import Foundation

struct PetInfo {
    let name: String
    let age: Int
    let species: Species
//    let photo: String
}

enum Species {
    case cat, dog
}
