//
//  OutputLayer.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
//

import Foundation
import Upsurge


public class OutputLayer: Layer, InputandOutputLayerMethods {



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
        

    open func initializeLayer(outLayer:OutputLayer) -> OutputLayer {

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


    public func printLayer(layer: Layer) {
        print(" ~ [OUTPUT LAYER] ~")

        var n:Int = 1

        for neuron in layer.listOfNeurons {
            print("Neuron # \(n) :")
            print("Output Weights of Neuron \(n): \(neuron.weightsGoingOut)")
            n += 1
        }
    }
}
