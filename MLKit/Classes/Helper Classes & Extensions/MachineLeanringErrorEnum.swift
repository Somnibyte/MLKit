//
//  RegressionErrorEnum.swift
//  MLKit
//
//  Created by Guled on 7/10/16.
//  Copyright © 2016 Guled. All rights reserved.
//

import Foundation


enum MachineLearningError: Error {
    case lengthOfDataArrayNotEqual
    case modelHasNotBeenFit
    case invalidInput


    var description: String {
        switch(self) {
        case .lengthOfDataArrayNotEqual:
            return "No data was provided."
        case .modelHasNotBeenFit:
            return "You need to have fit a model first before computing the RSS/Cost Function. To fit your model, call the `train` method."
        case .invalidInput:
            return "Input was invalid."
        }
    }
}
