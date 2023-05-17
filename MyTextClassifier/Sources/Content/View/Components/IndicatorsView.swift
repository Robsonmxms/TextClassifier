//
//  IndicatorsView.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import SwiftUI

struct IndicatorsView: View {
    @EnvironmentObject var classifierModel: ClassifierModel

    var body: some View {
        HStack(spacing: 20){
            buildIndicator(
                name: "Train Accuracy",
                accuracy: classifierModel.trainAccuracy
            )
            buildIndicator(
                name: "Validation Accuracy",
                accuracy: classifierModel.validationAccuracy
            )
        }
    }

    private func buildIndicator(name: String,accuracy: Double) -> some View {
        return VStack(spacing: 10) {
            Gauge(value: accuracy, in: 0...100) {

            } currentValueLabel: {
                Text("\(Int(accuracy))%")
                    .foregroundColor(
                        getAccuracyColor(accuracy: accuracy)
                    )
            } minimumValueLabel: {
                Text("\(0)")
                    .foregroundColor(Color.red)
            } maximumValueLabel: {
                Text("\(100)")
                    .foregroundColor(Color.green)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(
                Gradient(colors: [.red, .yellow, .green])
            )

            Text(verbatim: name)
                .font(.title2)
        }
    }

    private func getAccuracyColor(accuracy: Double) -> Color {
        if accuracy >= 0 && accuracy < 33 {
            return .red
        } else if accuracy < 66 {
            return .yellow
        } else if accuracy <= 100 {
            return .green
        } else {
            fatalError("Accuracy value out of range")
        }
    }
}
