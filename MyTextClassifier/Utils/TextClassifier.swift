//
//  TextClassifier.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import SwiftUI
import CreateML
import UniformTypeIdentifiers
import SwiftyJSON

class TextClassifier{
    var data: MLDataTable?
    var trainingData: MLDataTable?
    var testingData: MLDataTable?
    var classifier: MLTextClassifier?

    var classifierModel: ClassifierModel

    init(
        with classifierModel: ClassifierModel
    ) {
        self.classifierModel = classifierModel
    }

    func trainClassifier() {
        self.data = getjsonAsMLDataTable()

        guard data != nil else {
            LogModel.singleton.logs.append("There is no data in MLDataTable")
            self.trainingData = nil
            self.testingData = nil
            self.classifier = nil
            return
        }

        getParameterNamesFromJson()

        (self.trainingData, self.testingData) = data!.randomSplit(by: 0.75, seed: 5)

        verifyTrainingDataRows()

        do {
            self.classifier = try MLTextClassifier(
                trainingData: self.trainingData!,
                textColumn: classifierModel.textColumn,
                labelColumn: classifierModel.validationColumn
            )

        } catch {
            LogModel.singleton.logs.append("Couldn't load text classifier: \(error)")
        }
    }

    private func getjsonAsMLDataTable() -> MLDataTable? {

        let jsonURL = URL(fileURLWithPath: classifierModel.filePath)

        do {
            let data = try MLDataTable(contentsOf: jsonURL)
            return data
        } catch {
            LogModel.singleton.logs.append("Couldn't load json file: \(error)")
            return nil
        }
    }

    private func getParameterNamesFromJson() {

        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: classifierModel.filePath))
            let json = try JSON(data: jsonData)

            guard let parameterNames = json.array?.first?.dictionary?.keys else {
                LogModel.singleton.logs.append("Couldn't read JSON keys")
                return
            }

            let orderedParameterNames = parameterNames.sorted(by: { $0 < $1 })

            if orderedParameterNames.count == 2 {
                classifierModel.textColumn = orderedParameterNames[1]
                classifierModel.validationColumn = orderedParameterNames[0]
            } else {
                LogModel.singleton.logs.append("JSON parameters are not 2")
            }

        } catch {
            LogModel.singleton.logs.append("Error reading JSON file: \(error)")
        }
    }

    private func verifyTrainingDataRows() {
        guard let trainingDataRows = self.trainingData?.size.rows else {
            LogModel.singleton.logs.append("There are no data rows")
            return
        }

        if trainingDataRows < 50 {
            LogModel.singleton.logs.append("Training Data Rows cannot be less than 50, but there are \(trainingDataRows)")
            return
        } else {
            LogModel.singleton.logs.append("Using \(trainingDataRows) rows to train")
        }
    }

    func getTrainingAccuracy() -> Double {
        guard let classifier = self.classifier else {
            LogModel.singleton.logs.append("There is no MLTextClassifier")
            return 0
        }
        return (1.0 - classifier.trainingMetrics.classificationError) * 100
    }

    func getValidationAccuracy() -> Double {
        guard let classifier = self.classifier else {
            LogModel.singleton.logs.append("There is no MLTextClassifier")
            return 0
        }
        return (1.0 - classifier.validationMetrics.classificationError) * 100
    }

    func getAccuracyDescription() -> String {
        let validation = self.getValidationAccuracy()
        let training = self.getTrainingAccuracy()

        let description = String("""


        Training accuracy: \(training)%
        Validation accuracy: \(validation)%


        """)

        return description
    }

    func getPrediction(from: String) -> String? {
        guard let classifier = self.classifier else {
            LogModel.singleton.logs.append("There is no MLTextClassifier")
            return nil
        }
        do {
            return try classifier.prediction(from: from)
        } catch {
            LogModel.singleton.logs.append("Couldn't predict: \(error)")
            return nil
        }
    }

    func saveClassifier(metaData: MLModelMetadata) {
        guard let classifier = self.classifier else {
            LogModel.singleton.logs.append("There is no MLTextClassifier")
            return
        }

        let savePanel = NSSavePanel()
        savePanel.title = "Save model file"
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        savePanel.directoryURL = URL(fileURLWithPath: documentsPath)

        let mlModelType = UTType(exportedAs: "mlmodel")
        savePanel.allowedContentTypes = [mlModelType]

        if savePanel.runModal() == NSApplication.ModalResponse.OK {
            guard let url = savePanel.url else {
                return
            }

            do {
                try classifier.write(
                    to: url,
                    metadata: metaData
                )
                LogModel.singleton.logs.append("File salved in: \(url.path)")
            } catch {
                LogModel.singleton.logs.append("Couldn't save text classifier: \(error)")
            }
        }


    }
}

