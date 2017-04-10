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
     The encode method converts a NueralNetwork object to an array of floats by taking the weights of each layer and placing them into an array.

     - parameter network: A NeuralNet Object.

     - returns: An array of Float values.
     */
    public static func encode(network: NeuralNetwork) -> [Float] {

        var genotypeRepresentation: [Float] = []

        for layer in network.layers {

            genotypeRepresentation += Array<Float>(layer.weights!.elements)
        }

        for layer in network.layers {
            genotypeRepresentation += Array<Float>(layer.bias!.elements)
        }

        return genotypeRepresentation
    }

    /**
     The decode method converts a genotype back to a NeuralNet object by taking each value from the genotype and mapping them to a neuron in a particular layer.

     - parameter network: A NeuralNet Object.

     - returns: An array of Float values.
     */
    public static func decode(genotype: [Float]) -> NeuralNetwork {

        // Create a new NueralNet
        let brain = NeuralNetwork(size: (6, 1))
        brain.addLayer(layer: Layer(size: (6, 12), activationType: .siglog))
        brain.addLayer(layer: Layer(size: (12, 1), activationType: .siglog))

        brain.layers[0].weights = Matrix<Float>(rows: 12, columns: 6, elements: ValueArray<Float>(Array<Float>(genotype[0...71])))
        brain.layers[0].bias = Matrix<Float>(rows: 12, columns: 1, elements: ValueArray<Float>(Array<Float>(genotype[72...83])))
        brain.layers[1].weights = Matrix<Float>(rows: 1, columns: 12, elements: ValueArray<Float>(Array<Float>(genotype[84...95])))
        brain.layers[1].bias = Matrix<Float>(rows: 1, columns: 1, elements: ValueArray<Float>([genotype[96]]))

        return brain
    }
}
