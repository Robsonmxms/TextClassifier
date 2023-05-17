//
//  JsonController.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 17/05/23.
//

import SwiftUI
import UniformTypeIdentifiers

class JsonController {
    private var filePath = ""

    init(){}

    func getJsonString() -> String {
        return """
                follow this structure:

                [
                   {
                        "text": "There is a text for validation",
                        "validation": "validation label"
                    },
                     {
                          "text": "There is a text for validation",
                          "validation": "validation label"
                      }
                ]

                """
    }

    func configureJson(jsonText: String) -> String {
        saveJSONToFile(jsonText)
        return filePath
    }

    private func saveJSONToFile(_ jsonText: String) {

        if let jsonData = jsonText.data(using: .utf8) {
            let savePanel = NSSavePanel()
            savePanel.title = "Save json file"
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            savePanel.directoryURL = URL(fileURLWithPath: documentsPath)

            let jsonType = UTType(exportedAs: "json")
            savePanel.allowedContentTypes = [jsonType]

            if savePanel.runModal() == NSApplication.ModalResponse.OK {
                guard let url = savePanel.url else {
                    return
                }

                do {
                    try jsonData.write(to: url)
                    LogModel.singleton.logs.append("JSON saved successfully in \(url.path)")
                    self.filePath = url.path()
                } catch {
                    LogModel.singleton.logs.append("Couldn't save json file: \(error)")
                }
            }
        } else {
            LogModel.singleton.logs.append("Failed to convert string to JSON data")
        }
    }
}
