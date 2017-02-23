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

public class InputLayer: Layer, InputandOutputLayerMethods {


    fileprivate var _listOfNeurons: [Neuron]!
    fileprivate var _numberOfNueronsInLayer: Int!

    public var listOfNeurons: [Neuron] {

        get {
            return _listOfNeurons
        }

        set {
            return _listOfNeurons = newValue
        }
    }

    public var numberOfNueronsInLayer: Int {

        get {
            return _numberOfNueronsInLayer
        }

        set {
            return _numberOfNueronsInLayer = newValue
        }

    }


    /**
     The initializeLayer method initializes an InputLayer object by creating Neurons with random weights and then filling the listOfNeurons attribute with the correct number of Neurons specificed by the developer.

     - parameter inputLayer: An InputLayer Object

     - returns: An InputLayer Object
     */
    open func initializeLayer(inputLayer:InputLayer) -> InputLayer {

        var temporaryWeightsIn: [Float] = []
        var listOfNeurons: [Neuron] = []

        for var i in 0..<inputLayer.numberOfNueronsInLayer {

            var neuron = Neuron()

            temporaryWeightsIn.append(neuron.initializeNueron())

            neuron.weightsComingIn = ValueArray<Float>(temporaryWeightsIn)

            listOfNeurons.append(neuron)

            temporaryWeightsIn = []
        }

        inputLayer.listOfNeurons = listOfNeurons

        return inputLayer
    }


    public func printLayer(layer: Layer) {

        var n:Int = 1

        for neuron in layer.listOfNeurons {
            print("Neuron # \(n) :")
            print("Input Weights of Neuron \(n): \(neuron.weightsComingIn)")

            n += 1
        }
        
    }
    
}










