//
//  Neuron.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
// Architecture of the code inspired by Fábio M. Soares and Alan M.F Souza's implementation of a Neural Network -
// in their book Neural Network Programming in Java.

import Foundation
import Upsurge


open class Neuron {

    fileprivate var _weightsComingIn: ValueArray<Float>!
    fileprivate var _weightsGoingOut: ValueArray<Float>!
    fileprivate var _outputValue: Float!
    fileprivate var _error: Float!
    fileprivate var _sensibility: Float!

    var weightsComingIn: ValueArray<Float> { // List of input weights


        get {
            return _weightsComingIn
        }


        set {
            return _weightsComingIn = newValue
        }
    }

    var weightsGoingOut: ValueArray<Float> { // List of output weights

        get {
            return _weightsGoingOut
        }

        set {
            return _weightsGoingOut = newValue
        }

    }


    var outputValue: Float! { // List of output weights

        get {
            return _outputValue
        }

        set {
            return _outputValue = newValue
        }

    }

    var error: Float! { // List of output weights

        get {
            return _error
        }

        set {
            return _error = newValue
        }

    }

    var sensibility: Float! { // List of output weights

        get {
            return _sensibility
        }

        set {
            return _sensibility = newValue
        }

    }


    /**
     The initializeNeuron method initializes a neuron with a random Float value.
    */
    open func initializeNueron() -> Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }


}
