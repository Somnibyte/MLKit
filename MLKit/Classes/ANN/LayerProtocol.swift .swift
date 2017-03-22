//
//  LayerProtocol.swift .swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
// Architecture of the code inspired by Fábio M. Soares and Alan M.F Souza's implementation of a Neural Network -
// in their book Neural Network Programming in Java.

import Foundation
import Upsurge

/// The Layer Protocol defines what attributes and methods a Layer Object must have.
public protocol Layer {

    /// List of Neuron Object in a particular layer.
    var listOfNeurons: [Neuron] { get set }

    /// Number of Neurons in a particular layer.
    var numberOfNeuronsInLayer: Int { get set }

}
