//
//  PersistedColor.swift
//  SimbirNote
//
//  Created by Mac on 16.12.2024.
//

import UIKit
import RealmSwift

final class PersistedColor: EmbeddedObject {
    @Persisted var hexValue: String = "#FFFFFF"
    @Persisted var nameColor: String = "Цвет по умолчанию"
    
    var color: UIColor {
        get {
            UIColor(hex: hexValue) ?? .white
        }
        set {
            hexValue = newValue.toHex() ?? "#FFFFFF"
        }
    }
}
