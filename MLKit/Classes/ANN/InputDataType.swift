//
//  InputDataType.swift
//  Pods
//
//  Created by Guled  on 4/7/17.
//
//

import Foundation

/// Data structure the helps with neural network I/O.
public struct InputDataType {

    /// Array of tuples (x,y) where x is your training data and y is your output data.
    var data: [(input: [Float], target: [Float])]

    /// Number of elements in 'data' attribute.
    var lengthOfTrainingData: Int {
        get {
            return data.count
        }
    }

    public init(data: [(input: [Float], target: [Float])]) {
        self.data = data
    }
}
