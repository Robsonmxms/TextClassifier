//
//  SaveMLModelPopoverModel.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 17/05/23.
//

import SwiftUI

class SaveMLModelPopoverModel: ObservableObject {
    @Published var author = ""
    @Published var shortDescription = ""
    @Published var version = ""

    init(){}
}
