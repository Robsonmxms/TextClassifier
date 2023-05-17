//
//  ClassifierModel.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import Foundation

class ClassifierModel: ObservableObject {
    @Published var filePath: String = ""
    @Published var textColumn: String = ""
    @Published var validationColumn: String = ""
    @Published var trainAccuracy: Double = 0
    @Published var validationAccuracy: Double = 0
    init(){}
}
