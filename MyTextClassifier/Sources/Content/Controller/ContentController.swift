//
//  ContentController.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 17/05/23.
//

import SwiftUI
import UniformTypeIdentifiers

class ContentController {
    private var dialog = NSOpenPanel()
    private var textClassifier: TextClassifier
    private var classifierModel: ClassifierModel
    private var model: ContentModel

    init(
        textClassifier: TextClassifier,
        classifierModel: ClassifierModel,
        model: ContentModel
    ){
        self.textClassifier =  textClassifier
        self.classifierModel = classifierModel
        self.model = model
    }

    func trainModelButtonAction() {
        textClassifier.trainClassifier()

        guard (textClassifier.data != nil) else {
            classifierModel.trainAccuracy = 0
            classifierModel.validationAccuracy = 0
            return
        }

        classifierModel.trainAccuracy = textClassifier.getTrainingAccuracy()
        classifierModel.validationAccuracy = textClassifier.getValidationAccuracy()

        LogModel.singleton.logs.append("trainAccuracy: \(classifierModel.trainAccuracy)")
        LogModel.singleton.logs.append("validationAccuracy: \(classifierModel.validationAccuracy)")

        model.isAbleToSave = true
    }

    func verifyButtonAction() {
        let predict = textClassifier.getPrediction(from: model.text)
        LogModel.singleton.logs.append(
            """
            text for prediction: \(model.text)
            prediction: \(predict ?? "Couldn't predict")
            """
        )
        model.text = ""
    }

    func getFilePath() {
        dialog.title = "Select a file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false
        dialog.canChooseFiles = true

        let jsonType = UTType(exportedAs: "json")
        dialog.allowedContentTypes = [jsonType]

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let url = dialog.url {
                LogModel.singleton.logs.append("Selected file path: \(url.path)")
                classifierModel.filePath = url.path
            }
        } else {
            LogModel.singleton.logs.append("User cancelled the dialog.")
        }
    }
}
