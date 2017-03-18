//
//  NNOperations.swift
//  Pods
//
//  Created by Guled  on 3/7/17.
//
//

import Foundation

/// The NNOperations (Nueral Network Operations) class has the objective of computing activation function values and the derivative of activation functions as well.
final class NNOperations {



    // MARK: - Public Methods
    /**
     The activationFunc method returns the appropriate output based on the function that is specified.

     - parameter fncType: ActivationFunctionType enum case
     - parameter value: A Float

     - returns: A Float
     */
    public static func activationFunc(fncType: ActivationFunctionType, value: Float) throws -> Float {

        switch fncType {
        case .step:
            return fncStep(val: value)
        case .linear:
            return fncLinear(val: value)
        case .siglog:
            return fncSigLog(val: value)
        case .hypertan:
            return fncHyperTan(val: value)
        case .softsign:
            return fncSoftSign(val: value)
        case .sinusoid:
            return fncSinusoid(val: value)
        case .gaussian:
            return fncGuassian(val: value)
        default:
            throw MachineLearningError.invalidInput
        }
    }

    /**
     The derivativeFunc method returns the appropriate output based on the derivative of a function that is specified.

     - parameter fncType: ActivationFunctionType enum case
     - parameter value: A Float

     - returns: A Float
     */
    public static func derivativeFunc(fncType: ActivationFunctionType, value: Float) throws -> Float {

        switch fncType {
        case .linear:
            return derivativeOfLinear(val: value)
        case .siglog:
            return derivativeOfSigLog(val: value)
        case .hypertan:
            return derivativeOfHyperTan(val: value)
        case .softsign:
            return derivativeOfSoftSign(val: value)
        case .sinusoid:
            return derivativeOfSinusoid(val: value)
        case .gaussian:
            return derivativeOfGaussian(val: value)
        default:
            throw MachineLearningError.invalidInput
        }
    }



    // MARK: Activation Functions

    private static func fncStep(val: Float) -> Float {
        return val >= 0 ? 1.0 : 0.0
    }

    private static func fncLinear(val: Float) -> Float {
        return val
    }

    private static func fncSigLog(val: Float) -> Float {
        return 1.0 / (1.0 + exp(-val))
    }

    private static func fncHyperTan(val: Float) -> Float {
        return tanh(val)
    }

    private static func fncSoftSign(val: Float) -> Float {
        return val / 1 + abs(val)
    }

    private static func fncSinusoid(val: Float) -> Float {
        return sin(val)
    }

    private static func fncGuassian(val: Float) -> Float {
        return exp(powf((-val), 2))
    }


    // MARK: Derivatives
    private static func derivativeOfLinear(val: Float) -> Float {
        return 1.0
    }

    private static func derivativeOfSigLog(val: Float) -> Float {
        return val * (1.0 - val)
    }

    private static func derivativeOfHyperTan(val: Float) -> Float {
        return (1.0 / powf(cosh(val), 2.0))
    }

    private static func derivativeOfSoftSign(val: Float) -> Float {
        return 1 / powf((1 + abs(val)), 2)
    }

    private static func derivativeOfSinusoid(val: Float) -> Float {
        return cosf(val)
    }

    private static func derivativeOfGaussian(val: Float) -> Float {
        return -2 * val * exp(powf((-val), 2))
    }


}
