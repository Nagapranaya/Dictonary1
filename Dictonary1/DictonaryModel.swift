//
//  DictonaryModel.swift
//  Dictonary1
//
//  Created by Pranaya on 8/13/24.
//

import Foundation
struct Dictonary: Codable{
    let word: String
    let meaning: [Meaning]
}
struct Meaning: Codable{
    let definations: [Definations]
}

struct Definations: Codable{
    let defination: String
}
