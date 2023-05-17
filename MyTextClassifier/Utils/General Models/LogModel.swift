//
//  JSONModel.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import Foundation

class LogModel: ObservableObject {

    static var singleton: LogModel = LogModel()

    @Published var logs: [String] = []

    private init(){}
}
