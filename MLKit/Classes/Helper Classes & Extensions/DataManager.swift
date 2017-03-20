//
//  DataManager.swift
//  MLKit
//
//  Created by Guled on 6/30/16.
//  Copyright © 2016 Guled. All rights reserved.
//

import Foundation
import Upsurge

open class MLDataManager {

    enum MLDataHandelingError: Error {
        case noData
        case incorrectFraction
        case unacceptableInput

        var description: String {
            switch(self) {
            case .noData:
                return "No data was provided."
            case .incorrectFraction:
                return "Your fraction must be between 1.0 and 0.0"
            case .unacceptableInput:
                return "Input was not accepted."
            }
        }
    }

    /**
     The mean method calculates the mean of an array of numbers (of any type using the NumericType protocol).

     - parameter data: An array of numbers.

     - returns: The mean of the array
     */
    open static func mean (_ data: Array<Float>) -> Float {
        let totalSum = data.reduce(0.0, +)
        let totalAmountOfData = Float(data.count)
        return totalSum / totalAmountOfData
    }

    /**
     The dataToMatrix method takes an array of features (which contain your data of a specific feature), along with your observations/output
     and turns your features into a Matrix of type Float and your output into an array in order to be processed by machine learning algorithms
     such as calculating the RSS/cost function for Regression.

     - parameter features: An array of your features (which are suppose to be arrays as well).
     - parameter output: An array of your observations/output.

     - returns: A tuple that consists of a matrix and a array of type ValueArray
     */
    open static func dataToMatrix (_ features: [Array<Float>], output: Array<Float>) -> (Matrix<Float>, ValueArray<Float>) {

        // Create Output Matrix
        let outputMatrix = Matrix<Float>(rows: output.count, columns: 1, elements: output)

        // Create "contant/intercept" list
        let constantArray = [Float](repeating: 1.0, count: features[0].count)
        var matrixAsArray: [[Float]] = []

        for (i, _) in constantArray.enumerated() {
            var newRow: [Float] = []

            newRow.append(constantArray[i])

            for featureArray in features {
                newRow.append(featureArray[i])
            }

            matrixAsArray.append(newRow)
        }

        let featureMatrix = Matrix<Float>(matrixAsArray)

        return (featureMatrix, outputMatrix.elements)
    }

    /**
     A method that takes in a string of arrays (if you read your data in from a CSV file) and converts it into an array of Float values.

     - parameter data: A string array that contains your feature data.

     - returns: An array of type Float.
     */
    open static func convertMyDataToFloat(_ data: Array<String>) throws -> Array<Float> {

        if data.count == 0 {
            throw MLDataHandelingError.noData
        }

        let floatData: Array<Float> = data.map { Float($0)! }
        return floatData
    }

    /**
     The split data method allows you to split your original data into training and testing sets (or training,validation, and testing sets). The method takes in your data
     and a fraction and splits your data based on the fraction you specify. So for example if you chose 0.5 (50%), you would get a tuple containing two halves of your data.

     - parameter data: An array of your feature data.
     - parameter fraction: The amount you want to split the data.

     - returns: A tuple that contains your split data. The first entry of your tuple (0) will contain the fraction of data you specified, and the last entry of your tuple (1) will
     contain whatever data is left.
     */
    open static func splitData(_ data: Array<Float>, fraction: Float) throws -> (Array<Float>, Array<Float>) {

        if data.count == 0 {
            throw MLDataHandelingError.noData
        }

        if (fraction == 1.0 || fraction == 0.0 || fraction >= 1.0) {
            throw MLDataHandelingError.incorrectFraction
        }

        let dataCount = Float(data.count)
        let split = Int(fraction * dataCount)
        let firstPortion = data[0 ..< split]
        let secondPortion = data[split ..< data.count]
        let firstPortionAsArray = Array(firstPortion)
        let secondPortionAsArray = Array(secondPortion)

        return (firstPortionAsArray, secondPortionAsArray)
    }

    /**
     The randomlySplitData method allows you to split your original data into training and testing sets (or training,validation, and testing sets). The method takes in your data
     (shuffles it in order to make it completely random) and a fraction and splits your data based on the fraction you specify. So for example if you chose 0.5 (50%), you would get a tuple containing two halves of your data (that have been randomly shuffled).

     - parameter data: An array of your feature data.
     - parameter fraction: The amount you want to split the data.

     - returns: A tuple that contains your split data. The first entry of your tuple (0) will contain the fraction of data you specified, and the last entry of your tuple (1) will
     contain whatever data is left.
     */
    open static func randomlySplitData(_ data: Array<Float>, fraction: Float) throws -> (Array<Float>, Array<Float>) {

        if data.count == 0 {
            throw MLDataHandelingError.noData
        }

        if (fraction == 1.0 || fraction == 0.0 || fraction >= 1.0) {
            print("Your fraction must be between 1.0 and 0.0")
            throw MLDataHandelingError.incorrectFraction
        }

        // Shuffle the users input
        var shuffledData = data.shuffle()

        let dataCount = Float(data.count)
        let split = Int(fraction * dataCount)
        let firstPortion = shuffledData[0 ..< split]
        let secondPortion = shuffledData[split ..< data.count]
        let firstPortionAsArray = Array(firstPortion)
        let secondPortionAsArray = Array(secondPortion)

        return (firstPortionAsArray, secondPortionAsArray)
    }

    /**
     The convertDataToPolynomialOfDegree function takes your array of data from 1 feature and allows you to create complex models
     by raising your data up to the power of the degree parameter. For example if you pass in 1 feature (ex: [1,2,3]), and a degree of 3, the method
     will return 3 arrays as follows:  [ [1,2,3], [1,4,9], [1, 8, 27] ].

     - parameter data: An array of your feature data.

     - returns: An array of your features. The first will be your original data that was passed in since all the data within your feature was already raised to the
     first power. Subsequent arrays will consist of your data being raised up to a certain degree.
     */
    open static func convertDataToPolynomialOfDegree(_ data: Array<Float>, degree: Int) throws -> [Array<Float>] {

        if data.count == 0 {
            throw MLDataHandelingError.noData
        }

        if degree < 1 {
            throw MLDataHandelingError.unacceptableInput
        }

        // Array of features
        var features: [Array<Float>] = []

        // Set the feature passed in as the first entry of the array since this is considered as "power_1" or "to the power of 1"
        features.append(data)

        if degree > 1 {
            // Loop over remaining degrees
            // range usually starts at 0 and stops at the endpoint-1. We want it to start at 2 and stop at degree
            for power in 2..<(degree + 1) {
                let newFeature = data.map { powf($0, Float(power)) }
                features.append(newFeature)
            }
        }

        return features
    }

    /**
     The normalizeFeatures method calculates the l2 norm of your feature and output vectors.

     - parameter features: Your feature vector.
     - parameter output: Your output vector.

     - returns: A matrix of your normalized data.
     */
    open static func normalizeFeatures(_ features: [Array<Float>], output: Array<Float>) -> Matrix<Float> {

        let featureMatrixAndOutput = dataToMatrix(features, output: output)

        let normalizedFeatures = transpose(normalize(featureMatrixAndOutput.0))

        return normalizedFeatures
    }

}
