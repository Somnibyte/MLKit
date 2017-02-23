//
//  NeuralNet.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
//

import Foundation
import Upsurge


open class NeuralNet {

    fileprivate var inputLayer: InputLayer!
    fileprivate var hiddenLayer: HiddenLayer!
    fileprivate var listOfHiddenLayers: [HiddenLayer]!
    fileprivate var outputLayer: OutputLayer!
    fileprivate var numberOfHiddenLayers: Int!

    public init() {}
    
    open func initializeNet(){

        inputLayer = InputLayer()
        inputLayer.numberOfNueronsInLayer = 2

        numberOfHiddenLayers = 2
        listOfHiddenLayers = []

        for var i in 0..<numberOfHiddenLayers {

            hiddenLayer = HiddenLayer()
            hiddenLayer.numberOfNueronsInLayer = 3
            listOfHiddenLayers.append(hiddenLayer)

        }

        outputLayer = OutputLayer()
        outputLayer.numberOfNueronsInLayer = 1

        inputLayer = inputLayer.initializeLayer(inputLayer: inputLayer)

        listOfHiddenLayers = hiddenLayer.initializeLayer(hiddenLayer: hiddenLayer, listOfHiddenLayers: listOfHiddenLayers, inputLayer: inputLayer, outputLayer: outputLayer)

        outputLayer = outputLayer.initializeLayer(outLayer: outputLayer)

    }

    open func printNet(){

        inputLayer.printLayer(layer: inputLayer)
        print()
        hiddenLayer.printLayer(listOfHiddenLayers: listOfHiddenLayers)
        print()
        outputLayer.printLayer(layer: outputLayer)
    }
}
