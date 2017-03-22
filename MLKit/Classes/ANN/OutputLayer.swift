//
//  OutputLayer.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
//
// Architecture of the code inspired by Fábio M. Soares and Alan M.F Souza's implementation of a Neural Network -
// in their book Neural Network Programming in Java.

import Foundation
import Upsurge

/// The OutputLayer class represents the output layer of a NueralNet object.
public class OutputLayer: Layer {

    fileprivate var _listOfNeurons: [Neuron]
    fileprivate var _numberOfNeuronsInLayer: Int

    /// List of neurons associated with the output layer
    public var listOfNeurons: [Neuron] {

        get {
            return _listOfNeurons
        }

        set {
            return _listOfNeurons = newValue
        }
    }

    /// Number of neurons in the output layer
    public var numberOfNeuronsInLayer: Int {

        get {
            return _numberOfNeuronsInLayer
        }

        set {
            return _numberOfNeuronsInLayer = newValue
        }

    }

    /**
     Output Layer Init

     - parameter numberOfNeuronsInLayer: The number of neurons for the output layer.

     */
    init(numberOfNeuronsInLayer: Int) {

        var temporaryWeightsOut: [Float] = []
        var listOfNeurons: [Neuron] = []
        _numberOfNeuronsInLayer = numberOfNeuronsInLayer

        for var i in 0..<numberOfNeuronsInLayer {

            var neuron = Neuron()

            temporaryWeightsOut.append(neuron.initializeNeuron())

            neuron.weightsGoingOut = ValueArray<Float>(temporaryWeightsOut)

            listOfNeurons.append(neuron)

            temporaryWeightsOut = []
        }

        _listOfNeurons = listOfNeurons
    }

    /**
     The description variable prints the output layers neurons.
    */
    public var description: String {

        let header = " ~ [OUTPUT LAYER] ~"

        var n: Int = 1

        var neuronStrings = ""
        for neuron in self.listOfNeurons {
            neuronStrings += "Neuron # \(n) :\n"
            neuronStrings += "Output Weights of Neuron \(n): \(neuron.weightsGoingOut)\n"
            n += 1
        }

        return header + "\n" + neuronStrings
    }

}
