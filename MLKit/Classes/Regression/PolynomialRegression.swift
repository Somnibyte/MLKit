//
//  PolynomialRegression.swift
//  MLKit
//
//  Created by Guled on 7/2/16.
//  Copyright © 2016 Guled. All rights reserved.
//

import Foundation
import Upsurge

open class PolynomialLinearRegression {

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

    public init() {
        costFunctionResult = 0.0
    }

    /**
     The fit method fits/trains your model and returns your regression coefficients/weights. The methods applies gradient descent
     as a means to find the most optimal regression coefficients for your model.

     - parameter features: An array of all of your features.
     - parameter output: An array of your observations/output.
     - parameter intialWeights: A row or column matrix of your initial weights. If you have no initial weights simply pass in a zero matrix of type Matrix (check the Upsurge framework for details on this type).
     - parameter stepSize: The amount of "steps" you want to take in the gradient descent process.
     - parameter tolerance: The stopping point. Since it might take awhile to hit 0 you can set a tolerance to stop at a specific point.

     - returns: A Matrix of type Float consisting your regression coefficients/weights.
     */
    open func train(_ features: [Array<Float>], output: Array<Float>, initialWeights: Matrix<Float>, stepSize: Float, tolerance: Float) throws -> Matrix<Float> {

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

        // Main ML Algorithm
        var converged = false
        var predictions: ValueArray<Float>!
        var errors: ValueArray<Float> = ValueArray<Float>()
        let weights = initialWeights
        var gradientSumOfSquares = Float(0.0)
        var derivative = Float(0.0)

        // Convert the users array of features and output into matrices and vectors
        let featureMatrixAndOutput = MLDataManager.dataToMatrix(features, output: output)
        let featureMatrix = featureMatrixAndOutput.0
        let outputVector = featureMatrixAndOutput.1

        while !converged {

            predictions = predictEntireMatrixOfFeatures(featureMatrix, yourWeights: weights)
            errors = outputVector - predictions

            gradientSumOfSquares = Float(0.0)

            for i in 0...weights.count - 1 {

                derivative = getFeatureDerivative(errors, feature: featureMatrix.column(i))
                gradientSumOfSquares = gradientSumOfSquares + (derivative * derivative)

                weights.elements[i] = weights.elements[i] + (stepSize * derivative)

            }

            gradientSumOfSquares = sqrt(gradientSumOfSquares)

            if gradientSumOfSquares < tolerance {
                converged = true
            }
        }

        // Set weights
        self.finalWeights = weights

        return weights
    }

    /**
     The RSS method computes the residual sum of squares or the cost function of your model.

     - parameter features: An array of numbers.
     - parameter observation: An array of your observations/output.
     - returns: The cost of your model (a.k.a The Residual Sum of Squares).
     */
    open func RSS(_ features: [Array<Float>], observation: Array<Float>) throws -> Float {
        // Check if the users model has fit to their data
        if self.finalWeights == nil {
            print("You need to have fit a model first before computing the RSS/Cost Function.")
            throw MachineLearningError.modelHasNotBeenFit
        }

        // First get the predictions
        let yActual = observation
        let featureMatrixAndOutput = MLDataManager.dataToMatrix(features, output: observation)
        let featureMatrix = featureMatrixAndOutput.0
        let yPredicted = predictEntireMatrixOfFeatures(featureMatrix, yourWeights: self.finalWeights)

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
     when fitting your model (using the fit() method).

     - parameter inputVector: An array of input (depends on how many features you used to fit your model)
     - parameter weights: An array of your weights. This can be obtained by fitting your model before getting a prediction.
     - returns: A prediction (of type Float).
     */
    open func predict(_ inputVector: ValueArray<Float>, yourWeights: ValueArray<Float>) -> Float {

        let prediction: Float = inputVector • yourWeights

        return prediction
    }

    /**
     The predictEntireMatrixOfFeatures is used for making predictions using all of your feature data.

     - parameter inputMatrix: You need to utilize the dataToMatrix() method from the MLDataManager class in order to convert your array of features into a matrix. inputMatrix is a
     matrix that consists of all of your features.
     - parameter weights: A matrix that consists of your weights.
     - returns: An array of predictions (of type Float)
     */
    open func predictEntireMatrixOfFeatures(_ inputMatrix: Matrix<Float>, yourWeights: Matrix<Float>) -> ValueArray<Float> {

        let predictions = inputMatrix * yourWeights

        return predictions.elements
    }

    private func getFeatureDerivative(_ errors: ValueArray<Float>, feature: ValueArraySlice<Float>) -> Float {

        let derivative = 2 * (errors • feature)

        return derivative
    }

    /**
     The getWeightsAsMatrix function returns your weights.
     */
    open func getWeightsAsMatrix() -> Matrix<Float> {
        return self.finalWeights
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
