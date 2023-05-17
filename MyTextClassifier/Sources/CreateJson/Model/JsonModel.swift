//
//  JsonModel.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 17/05/23.
//

import Foundation

class JsonModel: ObservableObject {
    @Published var isAvailableToSave = false
    @Published var jsonText = ""
}
