//
//  FileManager-DocumentsDirectory.swift
//  Bucketlist
//
//  Created by Alberto Peinado Santana on 29/8/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
