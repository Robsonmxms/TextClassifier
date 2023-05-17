//
//  SaveMLModelPopoverController.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 17/05/23.
//

import SwiftUI
import CreateML

class SaveMLModelPopoverController {

    init(){}

    func saveMLModel(
        textClassifier: inout TextClassifier,
        model: SaveMLModelPopoverModel
    ) {
        let metadata = MLModelMetadata(
            author: model.author,
            shortDescription: model.shortDescription,
            version: model.version
        )
        textClassifier.saveClassifier(metaData: metadata)
    }
}
