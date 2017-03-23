//
//  RidgeRegression.swift
//  MLKit
//
//  Created by Guled on 7/10/16.
//  Copyright © 2016 Guled. All rights reserved.
//

import Foundation
import Upsurge

open class RidgeRegression {

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
        costFunctionResult  = 0.0
    }

    /**
     The fit method fits/trains your model and returns your regression coefficients/weights. The methods applies gradient descent
     as a means to find the most optimal regression coefficients for your model.

     - parameter features: An array of all of your features.
     - parameter output: An array of your observations/output.
     - parameter initialWeights: A row or column matrix of your initial weights. If you have no initial weights simply pass in a zero matrix of type Matrix (check the Upsurge framework for details on this type).
     - parameter stepSize: The amount of "steps" you want to take in the gradient descent process.
     - parameter maxIterations : Defines the maximum number of iterations and takes gradient steps (based on your stepSize) until we reach this maximum number.

     - returns: A Matrix of type Float consisting your regression coefficients/weights.
     */
    open func train(_ features: [Array<Float>], output: Array<Float>, initialWeights: Matrix<Float>, stepSize: Float, l2Penalty: Float, maxIterations: Float = 100) throws -> Matrix<Float> {

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
        var predictions: ValueArray<Float>!
        var errors: ValueArray<Float> = ValueArray<Float>()
        let weights = initialWeights
        var derivative = Float(0.0)
        var iterations = Float(0.0)

        // Convert the users array of features and output into matrices and vectors
        let featureMatrixAndOutput = MLDataManager.dataToMatrix(features, output: output)
        let featureMatrix  = featureMatrixAndOutput.0
        let outputVector = featureMatrixAndOutput.1

        //while not reached maximum number of iterations:
        while iterations < maxIterations {

            // compute the predictions based on featureMatrix  and weights
            predictions = predictEntireMatrixOfFeatures(featureMatrix, yourWeights: weights)

            // compute the errors as predictions - output
            errors = predictions - outputVector

            for i in 0...weights.count - 1 {

                // compute the derivative for weight[i].
                if i == 0 {
                    derivative = getFeatureDerivative(errors, feature: featureMatrix .column(i), weight: weights.elements[i], l2Penalty: l2Penalty, featureIsConstant: false)
                } else {
                    derivative = getFeatureDerivative(errors, feature: featureMatrix .column(i), weight: weights.elements[i], l2Penalty: l2Penalty, featureIsConstant: true)
                }

                // subtract the step size times the derivative from the current weight
                weights.elements[i] = weights.elements[i] - (stepSize * derivative)
            }

            //print(weights)
            iterations = iterations + 1
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
        let featureMatrix  = featureMatrixAndOutput.0
        let yPredicted = predictEntireMatrixOfFeatures(featureMatrix, yourWeights: self.finalWeights)

        // Then compute the residuals/errors
        let error: ValueArray<Float> = (yActual - yPredicted)

        // Then square and add them up
        let result = dot(error, error)

        // Set cost function
        self.costFunctionResult  = result

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

    private func getFeatureDerivative(_ errors: ValueArray<Float>, feature: ValueArraySlice<Float>, weight: Float, l2Penalty: Float, featureIsConstant: Bool) -> Float {

        var derivative = Float(0)

        if featureIsConstant {
            let sumOfPredictionsAndOutput = (2 * (errors • feature) )
            let productOfL2penaltyAndWeights = 2 * (l2Penalty * weight)
            derivative =  sumOfPredictionsAndOutput  +  productOfL2penaltyAndWeights
        } else {
            let sumOfPredictionsAndOutput = (2 * (errors • feature) )
            derivative = sumOfPredictionsAndOutput
        }

        return derivative
    }

    func kFoldCrossValidation(_ k: Float, l2Penalty: Float, features: [Array<Float>], output: Array<Float>, stepSize: Float) -> Float {

        let n = features[0].count
        var totalError = Float(0.0)
        var validationSet: [Array<Float>] = []
        var trainingSet: [Array<Float>] = []
        var outputOfTrainingSet: Array<Float> = []
        var start = 0
        var end = 0

        for i in 0...(Int(k)-1) {
            trainingSet = []
            validationSet  = []
            outputOfTrainingSet = []

            start = (n*i)/Int(k)
            end = (n * (i+1))/Int(k)-1
            for feature in features {
                let validationSlice: Array<Float> = Array(feature[start...end])
                validationSet .append(validationSlice)

                var firstSegment = i==0 ? [] : feature[0...start-1]
                let secondSegment = end==(n-1) ? [] : feature[end+1...n-1]
                firstSegment.append(contentsOf: secondSegment)
                let trainingFeature: Array<Float> = Array(firstSegment)
                trainingSet.append(trainingFeature)
            }

            var firstSegmentOfTrainingSetOutput = start==0 ? [] : output[0...start-1]
            let secondSegementOfTrainingSetOutput = end==(n-1) ? [] : output[end+1...n-1]
            firstSegmentOfTrainingSetOutput.append(contentsOf: secondSegementOfTrainingSetOutput)
            outputOfTrainingSet = Array(firstSegmentOfTrainingSetOutput)

            let initialWeights  = Matrix<Float>(rows: trainingSet.count+1, columns: 1, elements: [Float](repeating: 0.0, count: trainingSet.count+1))
            var kFoldWeights: Matrix<Float>!
            let ridgeModel = RidgeRegression()
            kFoldWeights = try! ridgeModel.train(trainingSet, output: outputOfTrainingSet, initialWeights : initialWeights, stepSize: stepSize, l2Penalty: l2Penalty)

            // First get the predictions
            let yActual: Array<Float> = Array(output[start...end])
            let featureMatrixAndOutput = MLDataManager.dataToMatrix(validationSet, output: yActual)
            let validationMatrix = featureMatrixAndOutput.0
            let yPredicted = predictEntireMatrixOfFeatures(validationMatrix, yourWeights: kFoldWeights)

            // Then compute the residuals/errors
            let error: ValueArray<Float> = (yActual - yPredicted)

            // Then square and add them up
            let rssResult = dot(error, error)

            totalError += rssResult
        }

        return totalError/k
    }

    open func lowestAverageValidationError(_ features: [Array<Float>], output: Array<Float>, listOfTestL2Penalties: [Float], k: Float=10, stepSize: Float = 0.1) throws  -> Float {

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

        var min: [Float] = [0, 0]

        for (i, l2Penalty) in listOfTestL2Penalties.enumerated() {
            let error = kFoldCrossValidation(k, l2Penalty: l2Penalty, features: features, output: output, stepSize: stepSize)
            print("Error for L2 of \(l2Penalty) is: \(error)")
            if i == 0 {
                min[0] = error
                min[1] = l2Penalty
            } else if error < min[0] {
                min[0] = error
                min[1] = l2Penalty
            }
        }

        return min[1]
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
