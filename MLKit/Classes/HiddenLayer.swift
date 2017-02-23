//
//  HiddenLayer.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
//

import Foundation
import Upsurge


public class HiddenLayer: Layer {


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

        
    open func initializeLayer(hiddenLayer:HiddenLayer, listOfHiddenLayers:[HiddenLayer], inputLayer:InputLayer, outputLayer:OutputLayer) -> [HiddenLayer] {


        var weightsComingIn:[Float] = []
        var weightsGoingOut:[Float] = []
        var listOfNeurons:[Neuron] = []

        var numberOfHiddenLayers = listOfHiddenLayers.count

        for var i in 0..<numberOfHiddenLayers {
            for var j in 0..<hiddenLayer.numberOfNueronsInLayer {

                // Initialize Neuron 
                var neuron = Neuron()

                // Offsets 
                var limitIn:Int!
                var limitOut:Int!


                if i == 0 { // First hidden Layer will recieve the inputLayers number of neurons
                    limitIn = inputLayer.numberOfNueronsInLayer

                    if numberOfHiddenLayers > 1{ // If we have more hidden layers, check for them. 
                        limitOut = listOfHiddenLayers[i + 1].numberOfNueronsInLayer
                    }else{ // Otherwise set limitOut to the current number of neurons
                        limitOut = listOfHiddenLayers[i].numberOfNueronsInLayer
                    }

                }else if i == numberOfHiddenLayers - 1 { // Last Hidden Layer
                    limitIn =  listOfHiddenLayers[i - 1].numberOfNueronsInLayer // # of neurons from previous layer 
                    limitOut = outputLayer.numberOfNueronsInLayer // # of neurons from the output layer
                }else{ // We are in the middle hidden layers
                    limitIn =  listOfHiddenLayers[i - 1].numberOfNueronsInLayer // # of neurons from previous hidden layer
                    limitOut = listOfHiddenLayers[i + 1].numberOfNueronsInLayer// # of neurons of successor hidden layer
                }


                for var k in 0..<limitIn {
                    weightsComingIn.append(neuron.initializeNueron())
                }

                for var k in 0..<limitOut {
                    weightsGoingOut.append(neuron.initializeNueron())
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

    open func printLayer(listOfHiddenLayers:[HiddenLayer]){
        print(" ~ [HIDDEN LAYER] ~")

        var h:Int = 1

        for hiddenLayer in listOfHiddenLayers {
            print("Hidden Layer # \(h)")

            var n:Int = 1

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























