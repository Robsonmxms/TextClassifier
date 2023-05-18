//
//  ContentModel.swift
//  MyTextClassifier
//
//  Created by Robson Lima Lopes on 16/05/23.
//

import Foundation

class ContentModel: ObservableObject {
    @Published var text: String = ""
    @Published var isSavePopoverVisible = false
    @Published var isAbleToTrain = false
    @Published var isAbleToSave = false
    @Published var isAbleToVerify = false
    @Published var isAbleToDeleteText = false
    @Published var isAbleToClear = false
    init(){}
}
