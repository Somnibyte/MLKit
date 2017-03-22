//
//  RegressionErrorEnum.swift
//  MLKit
//
//  Created by Guled on 7/10/16.
//  Copyright © 2016 Guled. All rights reserved.
//

import Foundation

enum MachineLearningError: Error {

    /// Not enough data or no data was provided to a particular method
    case lengthOfDataArrayNotEqual

    /// The model was not fit on any data
    case modelHasNotBeenFit

    /// A method took invalid data as a parameter.
    case invalidInput

    /// Description for MachineLearningError enum

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
