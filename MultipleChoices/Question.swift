//
//  Question.swift
//  MultipleChoices
//
//  Created by Wen Luo on 2022/1/27.
//

import Foundation
import CodableCSV
import UIKit

struct Question: Codable {
    let question: String
    var choices: String
    let answer: String
    let point: Int
}

extension Question {
    static var data: [Self] {
        var array = [Self]()
        if let data = NSDataAsset(name: "questions")?.data {
            let decoder = CSVDecoder {
                $0.headerStrategy = .firstLine
            }
            do {
                array = try decoder.decode([Self].self, from: data)
            } catch {
                print(error)
            }
        }
        return array
    }
}
