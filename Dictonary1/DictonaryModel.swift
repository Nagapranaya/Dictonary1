//
//  DictonaryModel.swift
//  Dictonary1
//
//  Created by Pranaya on 8/13/24.
//

import Foundation
struct Dictonary: Codable{
    let word: String
    let meanings: [Meaning]
}
struct Meaning: Codable{
    let definitions: [Definations]
}

struct Definations: Codable{
    let definition: String
}
