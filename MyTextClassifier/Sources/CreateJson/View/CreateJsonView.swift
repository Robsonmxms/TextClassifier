//
//  JSONEditorView.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import SwiftUI

struct CreateJsonView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var classifierModel: ClassifierModel
    @StateObject private var model = JsonModel()
    private var controller = JsonController()
    
    var body: some View {

        VStack(alignment: .leading){
            Button("Save JSON") {
                classifierModel.filePath = controller.configureJson(jsonText: model.jsonText)
                dismiss()
            }.disabled(!model.isAvailableToSave)

            ZStack(alignment: .topLeading) {

                if model.jsonText.isEmpty {
                    Text(controller.getJsonString())
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                TextEditor(text: $model.jsonText)
                    .scrollContentBackground(.hidden)
                    .font(.title2)
            }
            .padding()
            .frame(width: SizeModel.width*0.9)
        }
        .padding()
        .frame(height: SizeModel.height*0.5)
        .navigationTitle("Create your own JSON")
        .onChange(of: model.jsonText.isEmpty) { newValue in
            model.isAvailableToSave = !newValue
        }
    }
}
