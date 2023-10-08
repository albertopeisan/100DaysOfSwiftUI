//
//  FileManager.swift
//  Flashzilla
//
//  Created by Alberto Peinado Santana on 25/9/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
