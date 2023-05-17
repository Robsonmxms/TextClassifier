//
//  SaveModelPopover.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import SwiftUI
import CreateML

struct SaveMLModelPopover: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var model = SaveMLModelPopoverModel()
    @State private var isAbleToSave = false
    private var controller = SaveMLModelPopoverController()
    private var textClassifier: TextClassifier?

    private var isModelChanged: Bool {
        return !model.author.isEmpty &&
        !model.shortDescription.isEmpty &&
        !model.version.isEmpty
    }

    init(with textClassifier: TextClassifier){
        self.textClassifier = textClassifier
    }

    var body: some View {

        VStack {
            Text("Text Model Metadata")
                .font(.title)
                .padding()

            VStack(spacing: 20){
                TextField("author", text: $model.author)
                    .textFieldStyle(.roundedBorder)
                TextField("short Description", text: $model.shortDescription)
                    .textFieldStyle(.roundedBorder)
                TextField("version", text: $model.version)
                    .textFieldStyle(.roundedBorder)
            }.padding()


            HStack{
                Button("Close") {
                    dismiss()
                }
                Button("OK") {
                    guard var textClassifier = textClassifier else {
                        LogModel.singleton.logs.append("There are no textClassifier to save")
                        return
                    }
                    controller.saveMLModel(textClassifier: &textClassifier, model: model)
                    dismiss()
                }.disabled(!isAbleToSave)
            }
            .onChange(of: isModelChanged) { newValue in
                isAbleToSave = newValue
            }
            .padding()
        }
        .frame(width: 400, height: 400)
        .cornerRadius(8)
    }
}
