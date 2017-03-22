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

/// The Neuron class defines a neuron to be used within a Layer object.
open class Neuron {

    /// List of input weights
    public var weightsComingIn: ValueArray<Float>!

    /// List of output weights
    public var weightsGoingOut: ValueArray<Float>!

    /// List of output weights
    public var outputValue: Float!

    /// List of output weights
    public var error: Float!

    /// List of output weights
    public var sensibility: Float!

    /**
     The initializeNeuron method initializes a neuron with a random Float value.
    */
    open func initializeNeuron() -> Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }

}
