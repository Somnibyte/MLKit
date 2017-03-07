//
//  GeneticOperations.swift
//  MLKit
//
//  Created by Guled  on 3/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MachineLearningKit

final class GeneticOperations {

    public static func encode(network: NeuralNet) -> [Float] {
        let inputLayerNuerons = network.inputLayer.listOfNeurons
        let hiddenLayerNeurons = network.hiddenLayer.listOfNeurons
        let outputLayerNeurons = network.outputLayer.listOfNeurons

        var genotypeRepresentation: [Float] = []

        for neuron in inputLayerNuerons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsComingIn
        }

        for neuron in hiddenLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsComingIn + neuron.weightsGoingOut
        }

        for neuron in outputLayerNeurons {
            genotypeRepresentation = genotypeRepresentation + neuron.weightsGoingOut
        }

        return genotypeRepresentation
    }

}
