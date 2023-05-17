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

    @State private var jsonInformationsViewIsPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack(alignment: .top){
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
                }).disabled(!model.isAbleToClear)
            }.frame(width: SizeModel.width*0.82)
        }
        .padding()
        .onAppear{
            textClassifier = TextClassifier(with: classifierModel)
            controller = ContentController(
                textClassifier: textClassifier!,
                classifierModel: classifierModel,
                model: model
            )
            jsonInformationsViewIsPresented = true
        }

    }

    var jsonInformationsView: AnyView {
        if jsonInformationsViewIsPresented {
            return AnyView(JSONInformationsView(with: controller!)
                .environmentObject(classifierModel))
        } else {
            return AnyView(EmptyView())
        }
    }

    var modelStatusView: some View {
        HStack(spacing:20) {
            VStack(alignment: .leading){
                Button("Train model", action: {
                    controller!.trainModelButtonAction()
                }).disabled(!model.isAbleToTrain)

                Button("Save model", action: {
                    model.isSavePopoverVisible.toggle()
                }).disabled(!model.isAbleToSave)
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
                }).disabled(!model.isAbleToVerify)
                Button("Delete", action: {
                    model.text = ""
                }).disabled(!model.isAbleToDeleteText)
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
        }.padding()
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
