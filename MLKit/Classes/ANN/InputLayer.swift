//
//  InputLayer.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
// Architecture of the code inspired by Fábio M. Soares and Alan M.F Souza's implementation of a Neural Network -
// in their book Neural Network Programming in Java.

import Foundation
import Upsurge

/// The InputLayer class represents the input layer of a NueralNet object.
public class InputLayer: Layer, CustomStringConvertible {

    fileprivate var _listOfNeurons: [Neuron]
    fileprivate var _numberOfNeuronsInLayer: Int

    /// List of neurons associated with the input layer
    public var listOfNeurons: [Neuron] {
        get {
            return _listOfNeurons
        }

        set {
            return _listOfNeurons = newValue
        }
    }

    /// Number of neurons in the input layer
    public var numberOfNeuronsInLayer: Int {
        get {
            return _numberOfNeuronsInLayer
        }

        set {
            return _numberOfNeuronsInLayer = newValue
        }
    }

    /**
     Input Layer Init

     - parameter numberOfNeuronsInLayer: The number of neurons for the input layer.

     */
    init(numberOfNeuronsInLayer: Int) {

        var temporaryWeightsIn: [Float] = []
        var listOfNeurons: [Neuron] = []
        _numberOfNeuronsInLayer = numberOfNeuronsInLayer + 1 // Bias Added

        for var i in 0..<(numberOfNeuronsInLayer+1) { // Bias Added

            var neuron = Neuron()

            temporaryWeightsIn.append(neuron.initializeNeuron())

            neuron.weightsComingIn = ValueArray<Float>(temporaryWeightsIn)

            listOfNeurons.append(neuron)

            temporaryWeightsIn = []
        }

        _listOfNeurons = listOfNeurons
    }

    init(neurons: [Neuron]) {
        _listOfNeurons = neurons
        _numberOfNeuronsInLayer = neurons.count
    }

    /**
     The description variable prints the input layers neurons.
     */
    public var description: String {

        let header = " ~ [INPUT LAYER] ~"

        var n: Int = 1

        var neuronStrings = ""
        for neuron in self.listOfNeurons {
            neuronStrings += "Neuron # \(n) :\n"
            neuronStrings += "Input Weights of Neuron \(n): \(neuron.weightsComingIn)\n"
            n += 1
        }
        return header + "\n" + neuronStrings
    }

}
