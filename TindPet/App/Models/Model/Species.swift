//
//  Species.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 10.08.2023.
//

import Foundation

enum Species {
    case cat, dog, unknown
}

extension Species {
    func localizedText() -> String {
        switch self {
        case .cat:
            return "Кошка"
        case .dog:
            return "Собака"

        default: return ""
        }
    }

    static func from(_ rawValue: Int) -> Species {
        switch rawValue {
        case 0: return .cat
        case 1: return .dog
        default: return .unknown
        }
    }
}
