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


public class OutputLayer: Layer, InputandOutputLayerMethods {



    fileprivate var _listOfNeurons: [Neuron]!
    fileprivate var _numberOfNueronsInLayer: Int!

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
    public var numberOfNueronsInLayer: Int {

        get {
            return _numberOfNueronsInLayer
        }

        set {
            return _numberOfNueronsInLayer = newValue
        }

    }


    /**
     The initializeLayer method initializes an OutputLayer object by creating Neurons with random weights and then filling the listOfNeurons attribute with the correct number of Neurons specificed by the developer.

     - parameter inputLayer: An OutputLayer Object.

     - returns: An OutputLayer Object.
     */
    open func initializeLayer(outLayer: OutputLayer) -> OutputLayer {

        var temporaryWeightsOut: [Float] = []
        var listOfNeurons: [Neuron] = []

        for var i in 0..<outLayer.numberOfNueronsInLayer {

            var neuron = Neuron()

            temporaryWeightsOut.append(neuron.initializeNueron())

            neuron.weightsGoingOut = ValueArray<Float>(temporaryWeightsOut)

            listOfNeurons.append(neuron)

            temporaryWeightsOut = []
        }

        outLayer.listOfNeurons = listOfNeurons

        return outLayer
    }

    // See Layer Protocol Comment
    public func printLayer(layer: Layer) {
        print(" ~ [OUTPUT LAYER] ~")

        var n: Int = 1

        for neuron in layer.listOfNeurons {
            print("Neuron # \(n) :")
            print("Output Weights of Neuron \(n): \(neuron.weightsGoingOut)")
            n += 1
        }
    }
}
