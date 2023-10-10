//
//  PetModelLoader.swift
//  TindPet
//
//  Created by Asya Checkanar on 03.10.2023.
//

import Foundation
import UIKit

protocol PetModelLoaderDelegate {
    func didGetPetModels(pets: [PetInfo])
}

class PetModelLoaderService {
    var delegate: PetModelLoaderDelegate?
    private func getDefaultImage(species: Int) -> UIImage {
        let name = species == 0 ? "NoPhotoCat" : "NoPhotoDog"
        let image = UIImage(named: name) ?? UIImage()
        return image
    }
    private func getPetImage(pet: PetInfo, completion: @escaping (UIImage) -> ()) {
        guard let photoUrl = pet.photo,
           let url = URL(string: photoUrl) else {
            completion(getDefaultImage(species: pet.species))
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            let resultImage = UIImage(data: data) ?? self.getDefaultImage(species: pet.species)
            completion(resultImage)
        }
    }
    func processPetDocs(_ petDocs: [PetInfo]) {
        var resultPets = [PetInfo]()
        for pet in petDocs {
            getPetImage(pet: pet) { [weak self] petImage in
                guard let strongSelf = self else { return }
                var petModel = pet
                petModel.image = petImage
                resultPets.append(petModel)
            }
        }
        delegate?.didGetPetModels(pets: resultPets)
    }
}

