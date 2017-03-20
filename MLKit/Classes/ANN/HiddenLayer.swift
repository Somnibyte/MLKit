//
//  HiddenLayer.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
//
// Architecture of the code inspired by Fábio M. Soares and Alan M.F Souza's implementation of a Neural Network -
// in their book Neural Network Programming in Java.

import Foundation
import Upsurge

/// The HiddenLayer class represents the hidden layer of a NueralNet object.
public class HiddenLayer: Layer {

    fileprivate var _listOfNeurons: [Neuron]!
    fileprivate var _numberOfNeuronsInLayer: Int!

    /// List of neurons associated with a particular hidden layer
    public var listOfNeurons: [Neuron] {

        get {
            return _listOfNeurons
        }

        set {
            return _listOfNeurons = newValue
        }
    }

    /// Number of neurons in a particular hidden layer
    public var numberOfNeuronsInLayer: Int {

        get {
            return _numberOfNeuronsInLayer
        }

        set {
            return _numberOfNeuronsInLayer = newValue + 1 // Don't forget BIAS
        }

    }

    /**
     The initializeLayer method initializes an HiddenLayer object by creating Neurons with random weights and then filling the listOfNeurons attribute with the correct number of Neurons specificed by the developer.

     - parameter listOfHiddenLayers: A list of HiddenLayer objects.
     - parameter inputLayer: The input layer (InputLayer Object).
     - paramter outputLayer: The output layer (OutputLayer Object).

     - returns: An InputLayer Object.
     */
    open func initializeLayer(inputLayer: InputLayer, listOfHiddenLayers: [HiddenLayer], outputLayer: OutputLayer) -> [HiddenLayer] {

        var weightsComingIn: [Float] = []
        var weightsGoingOut: [Float] = []
        var listOfNeurons: [Neuron] = []

        var numberOfHiddenLayers = listOfHiddenLayers.count

        for var i in 0..<numberOfHiddenLayers {
            for var j in 0..<self.numberOfNeuronsInLayer {

                // Initialize Neuron
                var neuron = Neuron()

                // Offsets
                var limitIn: Int = 0
                var limitOut: Int = 0

                if i == 0 { // First hidden Layer will recieve the inputLayers number of neurons
                    limitIn = inputLayer.numberOfNeuronsInLayer

                    if numberOfHiddenLayers > 1 { // If we have more hidden layers, check for them.
                        limitOut = listOfHiddenLayers[i + 1].numberOfNeuronsInLayer
                    } else if numberOfHiddenLayers == 1 { // Otherwise set limitOut to the current number of neurons
                        limitOut = outputLayer.numberOfNeuronsInLayer
                    }

                } else if i == numberOfHiddenLayers - 1 { // Last Hidden Layer
                    limitIn =  listOfHiddenLayers[i - 1].numberOfNeuronsInLayer // # of neurons from previous layer
                    limitOut = outputLayer.numberOfNeuronsInLayer // # of neurons from the output layer
                } else { // We are in the middle hidden layers
                    limitIn =  listOfHiddenLayers[i - 1].numberOfNeuronsInLayer // # of neurons from previous hidden layer
                    limitOut = listOfHiddenLayers[i + 1].numberOfNeuronsInLayer// # of neurons of successor hidden layer
                }

                // Bias not connected
                limitIn -= 1
                limitOut -= 1

                if j >= 1 {

                    for var k in 0...limitIn {
                        weightsComingIn.append(neuron.initializeNeuron())
                    }
                }

                for var k in 0...limitOut {
                    weightsGoingOut.append(neuron.initializeNeuron())
                }

                neuron.weightsComingIn = ValueArray<Float>(weightsComingIn)
                neuron.weightsGoingOut = ValueArray<Float>(weightsGoingOut)
                listOfNeurons.append(neuron)

                weightsComingIn = []
                weightsGoingOut = []

            }

            // Append the newly created Neurons to the appropriate hidden layer
            listOfHiddenLayers[i].listOfNeurons = listOfNeurons

            listOfNeurons = []
        }

        return listOfHiddenLayers
    }

    /**
     The printLayer prints the weights of a list of hidden layer objects.

     - parameter listOfHiddenLayers: A list of HiddenLayer objects.

     */
    open func printLayer(listOfHiddenLayers: [HiddenLayer]) {
        print(" ~ [HIDDEN LAYER] ~")

        var h: Int = 1

        for hiddenLayer in listOfHiddenLayers {
            print("Hidden Layer # \(h)")

            var n: Int = 1

            for neuron in hiddenLayer.listOfNeurons {

                print("Neuron # \(n)")
                print("Input Weights: \(neuron.weightsComingIn)")
                print("Output Weights: \(neuron.weightsGoingOut)")
                n += 1
            }

            h += 1
        }

    }
}
