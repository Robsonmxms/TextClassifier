//
//  ContentView.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 15/05/23.
//

import SwiftUI
import CreateML
import Combine

struct ContentView: View {
    @StateObject var classifierModel = ClassifierModel()
    @StateObject var model = ContentModel()
    @State private var controller: ContentController?
    @State var textClassifier: TextClassifier?
    @ObservedObject var logModel = LogModel.singleton

    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack(alignment: .top, spacing: 20){
                VStack(alignment: .leading, spacing: 40){
                    jsonInformationsView
                        .frame(width: SizeModel.width*0.42)

                    modelStatusView
                        .frame(width: SizeModel.width*0.4)
                }
                predictionView.frame(
                    width: SizeModel.width*0.4
                )
            }
            HStack(alignment: .bottom){
                logBox

                Button("Clear", action: {
                    logModel.logs = []
                })
                .destructiveStyle(model.isAbleToClear)
                .disabled(!model.isAbleToClear)
            }.frame(width: SizeModel.width*0.83)
        }
        .padding()
        .onAppear{
            textClassifier = TextClassifier(with: classifierModel)
            controller = ContentController(
                textClassifier: textClassifier!,
                classifierModel: classifierModel,
                model: model
            )
        }
    }

    var jsonInformationsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading,spacing: 10){
                    Button("Select JSON", action: {
                        controller!.getFilePath()
                    })
                    .accentStyle(true)

                    NavigationLink(
                        destination: CreateJsonView().environmentObject(classifierModel)
                    ) {
                        Text("Create JSON")
                    }
                    .accentStyle(true)
                }
                TextField("Enter the file path", text: $classifierModel.filePath)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    var modelStatusView: some View {
        HStack(spacing:20) {
            VStack(alignment: .leading){
                Button("Train model", action: {
                    controller!.trainModelButtonAction()
                })
                .accentStyle(model.isAbleToTrain)
                .disabled(!model.isAbleToTrain)

                Button("Save model", action: {
                    model.isSavePopoverVisible.toggle()
                })
                .accentStyle(model.isAbleToSave)
                .disabled(!model.isAbleToSave)
            }
            Spacer()
            IndicatorsView().environmentObject(classifierModel)
            Spacer()
        }.onChange(of: classifierModel.filePath.isEmpty){ newValue in
            model.isAbleToTrain = !newValue
        }
        .sheet(isPresented: $model.isSavePopoverVisible, content: {
            SaveMLModelPopover(with: textClassifier!)
        })
    }

    var predictionView: some View {
        HStack(alignment: .bottom) {
            textEditor.frame(
                height: SizeModel.height*0.3
            )
            VStack(alignment: .leading) {
                Button("Verify", action: {
                    controller!.verifyButtonAction()
                })
                .accentStyle(model.isAbleToVerify)
                .disabled(!model.isAbleToVerify)
                Button("Delete", action: {
                    model.text = ""
                })
                .destructiveStyle(model.isAbleToDeleteText)
                .disabled(!model.isAbleToDeleteText)
            }
        }.onChange(of: model.text.isEmpty){ newValue in
            model.isAbleToDeleteText = !newValue
            if textClassifier?.classifier != nil {
                model.isAbleToVerify = !newValue
            }

        }
    }

    var textEditor: some View {
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 10)
                .fill(.quaternary)

            if model.text.isEmpty {
                Text("Your text for validation")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            TextEditor(text: $model.text)
                .scrollContentBackground(.hidden)
                .font(.title2)
                .padding()
        }
    }

    var logBox: some View {
        ZStack(alignment: .top){
            RoundedRectangle(cornerRadius: 10)
                .fill(.quaternary)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(logModel.logs.reversed(), id: \.self) { text in
                        HStack {
                            Text(verbatim: text)
                                .foregroundColor(.green)
                                .lineLimit(nil)
                                .font(.title2)
                                .padding()
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }.frame(
            maxHeight: SizeModel.height*0.3
        )
        .onChange(of: logModel.logs.isEmpty) { newValue in
            model.isAbleToClear = !newValue
        }
    }
}
