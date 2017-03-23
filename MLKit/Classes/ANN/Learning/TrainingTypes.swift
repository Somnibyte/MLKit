//
//  TrainingTypes.swift
//  Pods
//
//  Created by Guled  on 2/24/17.
//
//

import Foundation

/// The TrainingType enum represents the type of neural network architecture you are using.
public enum TrainingType {
    /// Perceptron Architecture
    case perceptron
    /// Adaline Architecture
    case adaline
    /// BackPropagation Method
    case backpropagation
}

public extension TrainingType {

    /// Represents the Neural Network architecture your Neural Net object is using. trainingFunction returns the appropriate Neural Network Architecture Object (perceptron, adaline, or backpropagation)
    var trainingFunction: Training {
        switch self {
        case .perceptron:
            return Perceptron()
        case .adaline:
            return Adaline()
        case .backpropagation:
            return BackPropagation()
        }
    }
}
