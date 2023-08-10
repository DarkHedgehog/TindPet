//
//  PetCellModel.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import Foundation
import UIKit

struct PetInfoModel {
    var photo: UIImage
    var name: String
    var location: String
    var ageText: String
    var genderImage: UIImage
    var gender: String
    var status: String
    var statusColor: UIColor
    var isConatactButtonEnabled: Bool
    var ownerID: String
    var description: String
    var petID: String
    var ownerPhoto: UIImage
    var ownerName: String
    var species: Species

    init(_ info: PetInfo, owner: UserInfo? = nil) {
        photo = info.image ?? Constants.unsettedPetPhoto
        name = info.name
        location = Constants.unknownLocation
        ageText = info.age.toLocalizedAge()
        genderImage = info.species == 0 ? Constants.femaleImage : Constants.maleImage
        species = Species.from(info.species)
        gender = info.species == 0 ? Constants.femaleGender : Constants.maleGender
        status = Constants.statusReady
        statusColor = .systemGreen
        description = info.description ?? ""
        isConatactButtonEnabled = true
        ownerID = info.ownerID
        petID = info.petID
        ownerName = owner?.name ?? Constants.unknownOwnerName
        ownerPhoto = Constants.unsettedPersonPhoto
    }

    enum Constants {
        static let unsettedPetPhoto = UIImage(named: "paw")!
        static let unsettedPersonPhoto = UIImage(named: "person")!
        static let unknownLocation = "Unknown location"
        static let femaleImage = UIImage(named: "femaleSign")!
        static let maleImage = UIImage(named: "maleSign")!
        static let femaleGender = "Девочка"
        static let maleGender = "Мальчик"
        static let statusReady = "Владелец согласен"
        static let unknownOwnerName = "Лариса Ивановна"
    }
}
