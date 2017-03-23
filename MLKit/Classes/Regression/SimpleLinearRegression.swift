//
//  SimpleLinearRegression.swift
//  MLKit
//
//  Created by Guled on 6/29/16.
//  Copyright © 2016 Guled. All rights reserved.
//

import Foundation
import Upsurge

open class SimpleLinearRegression {

    fileprivate var _slope: Float!

    var slope: Float {

        get {
            return _slope
        }

        set {
            _slope = newValue
        }

    }

    fileprivate var _intercept: Float!

    var intercept: Float {

        get {
            return _intercept
        }

        set {
            _intercept = newValue
        }
    }

    fileprivate var _costFunctionResult: Float!

    var costFunctionResult: Float {

        get {
            return _costFunctionResult
        }

        set {
            _costFunctionResult = newValue
        }
    }

    fileprivate var _finalWeights: Matrix<Float>!

    var finalWeights: Matrix<Float> {

        get {
            return _finalWeights
        }

        set {
            return _finalWeights = newValue
        }
    }

    public init() {
        slope = 0.0
        intercept = 0.0
        costFunctionResult = 0.0
    }

    /**
     The fitUsingGradientDescent method fits/trains your model (that consists of one feature and one output array) and returns your regression coefficients/weights. The methods applies gradient descent
     as a means to find the most optimal regression coefficients for your model.

     - parameter inputFeature: An array of your feature. Only 1 feature is allowed. This class is used for simple experiments in which only 1 feature is allowed.
     - parameter output: An array of your observations/output.
     - parameter stepSize: The amount of "steps" you want to take in the gradient descent process.
     - parameter tolerance: The stopping point. Since it might take awhile to hit 0 you can set a tolerance to stop at a specific point.

     - returns: A tuple of your slope and intercept (your regression coefficients).
     */
    open func train(_ inputFeature: Array<Float>, output: Array<Float>, stepSize: Float, tolerance: Float) throws -> (Float, Float) {

        if (inputFeature.count != output.count) {

            print("The length of your input feature data and your output must be the same in order to utilize this function.")
            throw MachineLearningError.lengthOfDataArrayNotEqual
        }

        var converged = false // Convergence Boolean
        var currentSlope = Float(0.0) // Slope / Weight
        var currentIntercept = Float(0.0)
        var predictionsFromTrainingData = Array<Float>()
        var errors = Array<Float>()
        var sumOfErrors = Float(0.0)
        var adjustmentForIntercept = Float(0.0)
        var errorAndInputSum = Float(0.0)
        var adjustmentForSlope = Float(0.0)
        var gradientMagnitude = Float(0.0)

        // Function to subtract predictions from the actual observations
        let subtractPredictionsFromOutput = { (predictions: Array<Float>, output: Array<Float>) -> Array<Float> in
            var newData = Array<Float>()

            for (i, data) in predictions.enumerated() {
                let value = data - output[i]
                newData.append(value)
            }

            return newData
        }

        // Function to find the product of our errors and input feature data
        let findProductOfErrorAndInput = { () -> Array<Float> in

            var newData = Array<Float>()

            for (i, data) in errors.enumerated() {
                let value = data * inputFeature[i]
                newData.append(value)
            }

            return newData
        }

        while !converged {

            // Compute the predicted values given the current slope and intercept
            predictionsFromTrainingData = getTrainingDataPredictions(inputFeature, slope: currentSlope, intercept: currentIntercept)

            // Compute the prediction errors (prediction - Y)
            errors = subtractPredictionsFromOutput(predictionsFromTrainingData, output)

            // Update the intercept
            sumOfErrors = sum(errors)
            adjustmentForIntercept = stepSize * sumOfErrors
            currentIntercept = currentIntercept - adjustmentForIntercept

            // Update the slope
            let errorInputArr = findProductOfErrorAndInput()
            errorAndInputSum = sum(errorInputArr)
            adjustmentForSlope = stepSize * errorAndInputSum
            currentSlope = currentSlope - adjustmentForSlope

            // Compute the magnitude of the gradient
            let sumOfErrorsSquared = (sumOfErrors * sumOfErrors)
            let errorAndInputSumSquared = errorAndInputSum * errorAndInputSum
            gradientMagnitude = sqrt(sumOfErrorsSquared + errorAndInputSumSquared)

            // Check for convergence
            if gradientMagnitude < tolerance {
                converged = true
            }

        }

        self.slope = currentSlope
        self.intercept = currentIntercept

        return (currentSlope, currentIntercept)
    }

    /**
     The fitUsingNoGradientDescent method fits/trains your model by taking the derivative of the residual sum of squares formula (An .md file with the intuition behind this approach will be provided soon) and solves for your regression coefficients.

     - parameter inputFeature: An array of your feature. Only 1 feature is allowed. This class is used for simple experiments in which only 1 feature is allowed.
     - parameter output: An array of your observations/output.

     - returns: A tuple of your slope and intercept (your regression coefficients).
     */
    open func train(_ inputFeature: Array<Float>, output: Array<Float>) -> (Float, Float) {

        if (inputFeature.count == 0 || output.count == 0) {
            print("You need to have 1 feature array and 1 output array to utilize this function.")
            return (Float(-1), Float(-1))
        }

        if (inputFeature.count != output.count) {

            print("The length of your input feature data and your output must be the same in order to utilize this function.")
            return (Float(-1), Float(-1))
        }

        // The sum over all of our observations/output (y)
        let ySub_i = sum(output)

        // The sum over all of our input data (x)
        let xSub_i = sum(inputFeature)

        // The sum over all of our input data squared
        let dataSquared = inputFeature.map { $0 * $0 }
        let xSub_i_Squared = sum(dataSquared)

        // The sum over all of our input data and output data
        var inputAndOutputMultiplied: Array<Float> = []
        for (i, element) in inputFeature.enumerated() {
            let value = element * output[i]
            inputAndOutputMultiplied.append(value)
        }
        let xSub_i_ySub_i = sum(inputAndOutputMultiplied)

        // Calculate the slope (w1)
        let numerator = xSub_i_ySub_i - (Float(1.0) / Float(inputFeature.count)) * (ySub_i * xSub_i)
        let denominator = xSub_i_Squared - (Float(1.0) / Float(inputFeature.count)) * (xSub_i * xSub_i)
        let slope = numerator / denominator

        // Calculate the intercept
        let intercept = mean(output) - slope * mean(inputFeature)

        // Save the current slope and intercept
        self.slope = slope
        self.intercept = intercept

        return (slope, intercept)
    }

    /**
     The RSS method computes the residual sum of squares or the cost function of your model.

     - parameter inputFeature: An array of your feature. Only 1 feature is allowed. This class is used for simple experiments in which only 1 feature is allowed.
     - parameter output: An array of your observations/output.
     - parameter intercept: Your intercept weight (of type Float).
     - parameter slope: your slope weight (of type Float).

     - returns: The cost of your model (a.k.a The Residual Sum of Squares).

     */
    open func RSS (_ inputFeature: Array<Float>, output: Array<Float>, slope: Float, intercept: Float) -> Float {
        var sum = Float(0.0)
        for (i, _) in inputFeature.enumerated() {
            let value = (output[i] - predict(slope, intercept: intercept, inputValue: inputFeature[i]))
            let valueSquared = value * value
            sum = sum + valueSquared
        }

        // Save RSS/Cost
        self.costFunctionResult = sum

        return sum
    }

    /**
     The predict method is used for making one-time predictions by passing your intercept weight, slope weight, and an input value.

     - parameter intercept: Your intercept weight (of type Float).
     - parameter slope: your slope weight (of type Float).
     - paramter inputValue: An input value.

     - returns: A prediction (of type Float).
     */
    open func predict (_ slope: Float, intercept: Float, inputValue: Float) -> Float {
        let yHat = intercept + slope * inputValue
        return yHat
    }

    private func getTrainingDataPredictions (_ inputFeature: Array<Float>, slope: Float, intercept: Float) -> Array<Float> {

        var predictionsFromTrainingData = Array<Float>()

        for data in inputFeature {
            let yhat = predict(slope, intercept: intercept, inputValue: data)
            predictionsFromTrainingData.append(yhat)
        }

        return predictionsFromTrainingData
    }

    /**
     The getRegressionCoefficients function returns your slope and intercept.
    */
    open func getRegressionCoefficients() -> (Float, Float) {
        return (self.slope, self.intercept)
    }

}
