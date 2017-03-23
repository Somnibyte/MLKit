//
//  LassoRegression.swift
//  MLKit
//
//  Created by Guled on 7/30/16.
//  Copyright © 2016 Guled. All rights reserved.
//

import Foundation
import Upsurge

open class LassoRegression {

    fileprivate var _costFunctionResult: Float!

    /// Represents the RSS value of your model.
    var costFunctionResult: Float {

        get {
            return _costFunctionResult
        }

        set {
            _costFunctionResult = newValue
        }
    }

    fileprivate var _finalWeights: Matrix<Float>!

    /// Represents the weights of your model after it has been trained.
    var finalWeights: Matrix<Float> {

        get {
            return _finalWeights
        }

        set {
            return _finalWeights = newValue
        }
    }

    public init () {
        costFunctionResult = 0.0
    }

    /**
     - parameter features: Your feature vector.
     - parameter output: Your output vector.
     - parameter initialWeights: Your initial arbitrary weights.
     - parameter l1Penalty: An L1 Penalty value.
     - parameter tolerance: Threshold for gradient descent process.

     - returns:
     */
    open func train(_ features: [Array<Float>], output: Array<Float>, initialWeights: Matrix<Float>, l1Penalty: Float, tolerance: Float) throws -> Matrix<Float> {
        // Error Handeling

        // Check Feature Length
        var featureLength = 0

        for (i, featureArray) in features.enumerated() {

            if i == 0 {
                featureLength = featureArray.count
            }

            if featureArray.count != featureLength {
                throw MachineLearningError.lengthOfDataArrayNotEqual
            }
        }

        // Convert the users array of features and output into matrices and vectors
        let featureMatrixAndOutput = MLDataManager.dataToMatrix(features, output: output)
        let featureMatrix = featureMatrixAndOutput.0
        let normalizedFeatureMatrix = transpose(normalize(featureMatrix))

        var converged: Bool = false

        while converged == false {

            var changeForFullCycle: [Float] = []

            for i in (0..<initialWeights.elements.count) {

                let oldWeight = initialWeights.elements[i]

                initialWeights.elements[i] = lassoCoordinateDescentStep(i, featureMatrix: normalizedFeatureMatrix, output: output, weights: initialWeights, l1Penalty: l1Penalty)

                let change = abs(initialWeights.elements[i] - oldWeight)

                changeForFullCycle.append(change)
            }

            let maxChange = max(changeForFullCycle)

            if maxChange < tolerance {
                converged = true
            }
        }

        // set the weights
        self.finalWeights = initialWeights

        return initialWeights
    }

    private func lassoCoordinateDescentStep(_ i: Int, featureMatrix: Matrix<Float>, output: Array<Float>, weights: Matrix<Float>, l1Penalty: Float) -> Float {

        // Compute predictions
        let predictions = predictEntireMatrixOfFeatures(featureMatrix, yourWeights: weights)

        // Compute ro[i]
        let roAsValueArray: ValueArray<Float> = featureMatrix.column(i) * ((output - predictions) + weights.elements[i] * featureMatrix.column(i))

        let ro = sum(roAsValueArray)

        // Calculate new weight
        var newWeight: Float! = 0.0

        if i == 0 {
            newWeight = ro
        } else if ro < (-l1Penalty / 2.0) {
            newWeight = (ro + l1Penalty / 2.0)
        } else if ro > (l1Penalty / 2.0) {
            newWeight = (ro - l1Penalty / 2.0)
        } else {
            newWeight = 0.0
        }

        return newWeight
    }

    /**
     The RSS method computes the residual sum of squares or the cost function of your model.

     - parameter features: An array of numbers. Your features will automatically be normalized.
     - parameter observation: An array of your observations/output.
     - returns: The cost of your model (a.k.a The Residual Sum of Squares).
     */
    open func RSS(_ features: [Array<Float>], observation: Array<Float>) throws -> Float {
        // Check if the users model has fit to their data
        if self.finalWeights == nil {
            throw MachineLearningError.modelHasNotBeenFit
        }

        // First get the predictions
        let yActual = observation
        let featureMatrixAndOutput = MLDataManager.dataToMatrix(features, output: observation)
        let featureMatrix = featureMatrixAndOutput.0
        let normalizedFeatureMatrix = transpose(normalize(featureMatrix))
        let yPredicted = predictEntireMatrixOfFeatures(normalizedFeatureMatrix, yourWeights: self.finalWeights)

        // Then compute the residuals/errors
        let error: ValueArray<Float> = (yActual - yPredicted)

        // Then square and add them up
        let result = dot(error, error)

        // Set cost function
        self.costFunctionResult = result

        return result
    }

    /**
     The predict method is used for making one-time predictions by passing in an input vector and the weights you have generated
     when fitting your model (using the fit() method). Make sure your first feature is the constant 1 for the intercept.

     - parameter inputVector: An array of input (depends on how many features you used to fit your model)
     - parameter weights: An array of your weights. This can be obtained by fitting your model before getting a prediction.
     - returns: A prediction (of type Float).

     */
    open func predict(_ inputVector: ValueArray<Float>, yourWeights: ValueArray<Float>) -> Float {

        let prediction: Float = inputVector • yourWeights

        return prediction
    }

    /**
     The predictEntireMatrixOfFeatures is used for making predictions using all of your feature data. Before using this function normalize your features by calling the MLDataManagers normalizeFeatures static method.

     - parameter inputMatrix: You need to utilize the dataToMatrix() method from the MLDataManager class in order to convert your array of features into a matrix. inputMatrix is a
     matrix that consists of all of your features.
     - parameter weights: A matrix that consists of your weights.
     - returns: An array of predictions (of type Float)
     */
    open func predictEntireMatrixOfFeatures(_ inputMatrix: Matrix<Float>, yourWeights: Matrix<Float>) -> ValueArray<Float> {

        let predictions = inputMatrix * yourWeights

        return predictions.elements
    }

    /**
     The getWeightsAsValueArray function returns a value array that contains your weights.
     */
    open func getWeightsAsValueArray() -> ValueArray<Float> {
        return self.finalWeights.elements
    }

    /**
     The getWeightsAsArray function returns a array (of type Float) that contains your weights.
     */
    open func getWeightsAsArray() -> Array<Float> {
        return Array(self.finalWeights.elements)
    }
}
