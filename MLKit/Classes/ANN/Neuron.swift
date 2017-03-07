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

    /// List of input weights
    public var weightsComingIn: ValueArray<Float> {


        get {
            return _weightsComingIn
        }


        set {
            return _weightsComingIn = newValue
        }
    }

    /// List of output weights
    public var weightsGoingOut: ValueArray<Float> {

        get {
            return _weightsGoingOut
        }

        set {
            return _weightsGoingOut = newValue
        }

    }

    /// List of output weights
    public var outputValue: Float! {

        get {
            return _outputValue
        }

        set {
            return _outputValue = newValue
        }

    }

    /// List of output weights
    public var error: Float! {

        get {
            return _error
        }

        set {
            return _error = newValue
        }

    }

    /// List of output weights
    public var sensibility: Float! {

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
