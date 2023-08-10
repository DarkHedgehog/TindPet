//
//  Int+toLocalizedAge.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 08.08.2023.
//

import Foundation

extension Int {
    func toLocalizedAge() -> String {
        let value = self % 100
        switch value {
        case 1, 21, 31, 41, 51, 61, 71, 81, 91: return "\(self) год"
        case 2...4, 22...24, 32...34, 42...44, 52...54, 62...64, 72...74, 82...84, 92...94: return "\(self) года"
        default: return "\(self) лет"
        }
    }
}
