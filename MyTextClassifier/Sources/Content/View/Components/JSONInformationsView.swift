//
//  JSONInformationsView.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import SwiftUI

struct JSONInformationsView: View {

    private var controller: ContentController

    @EnvironmentObject var classifierModel: ClassifierModel

    init(with controller: ContentController) {
        self.controller = controller
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading,spacing: 10){
                    Button("Select JSON", action: {
                        controller.getFilePath()
                    })
                    NavigationLink(
                        destination: CreateJsonView().environmentObject(classifierModel)
                    ) {
                        Text("Create JSON")
                            .font(.body)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                TextField("Enter the file path", text: $classifierModel.filePath)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
