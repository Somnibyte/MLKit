//
//  GeneticOperations.swift
//  MLKit
//
//  Created by Guled  on 3/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MachineLearningKit
import Upsurge


/// The GeneticOperations class manages encoding genes into weights for the neural network and decoding neural network weights into genes. These methods are not provided in the framework itself, rather it was for the game example.
final class GeneticOperations {


    /**
     The encode method converts a NueralNet object to an array of floats by taking the weights of each layer and placing them into an array.

     - parameter network: A NeuralNet Object.

     - returns: An array of Float values.
     */
    public static func encode(network: NeuralNet) -> [Float] {

        let inputLayerNeurons = network.inputLayer.listOfNeurons
        let hiddenLayerNeurons = network.listOfHiddenLayers[0].listOfNeurons
        let outputLayerNeurons = network.outputLayer.listOfNeurons

        var genotypeRepresentation: [Float] = []

        for neuron in inputLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsComingIn
        }

        for neuron in hiddenLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsComingIn
        }

        for neuron in hiddenLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsGoingOut
        }

        for neuron in outputLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsGoingOut
        }

        print(genotypeRepresentation.count)

        return genotypeRepresentation
    }


    /**
     The decode method converts a genotype back to a NeuralNet object by taking each value from the genotype and mapping them to a neuron in a particular layer.

     - parameter network: A NeuralNet Object.

     - returns: An array of Float values.
     */
    public static func decode(genotype: [Float]) -> NeuralNet {

        // Create a new NueralNet
        let brain = NeuralNet(numberOfInputNeurons: 4, numberOfHiddenLayers: 1, numberOfNeuronsInHiddenLayer: 4, numberOfOutputNeurons: 1)

        brain.activationFuncType = .siglog

        brain.activationFuncTypeOfOutputLayer = .siglog

        // Convert genotype back to weights for each layer
        let inputLayerWeights: [Float] = Array<Float>(genotype[0...4])

        // First is bias neuron
        let hiddenLayerWeightsComingInForNeuron1: [Float] = Array<Float>(genotype[5...8])
        let hiddenLayerWeightsComingInForNeuron2: [Float] = Array<Float>(genotype[9...12])
        let hiddenLayerWeightsComingInForNeuron3: [Float] = Array<Float>(genotype[13...16])
        let hiddenLayerWeightsComingInForNeuron4: [Float] = Array<Float>(genotype[17...20])
        let hiddenLayerWeightsComingInForNeuron5: [Float] = Array<Float>(genotype[21...24])
        let hiddenLayerWeightsGoingOut: [Float] = Array<Float>(genotype[25...29])
        let outputLayerWeightGoingOut: Float = genotype[30]

        for (i, neuron) in brain.inputLayer.listOfNeurons.enumerated() {

            neuron.weightsComingIn = ValueArray<Float>([inputLayerWeights[i]])
        }

        for (i, neuron) in brain.listOfHiddenLayers[0].listOfNeurons.enumerated() {

            if i == 0 {
                continue
            } else if i == 1 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNeuron1)
            } else if i == 2 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNeuron2)
            } else if i == 3 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNeuron3)
            } else if i == 4 {
                neuron.weightsComingIn = ValueArray<Float>(hiddenLayerWeightsComingInForNeuron4)
            }
        }

        for (i, neuron) in brain.listOfHiddenLayers[0].listOfNeurons.enumerated() {

            neuron.weightsGoingOut = ValueArray<Float>([hiddenLayerWeightsGoingOut[i]])

        }

        brain.outputLayer.listOfNeurons[0].weightsGoingOut = ValueArray<Float>([outputLayerWeightGoingOut])

        return brain
    }
}
