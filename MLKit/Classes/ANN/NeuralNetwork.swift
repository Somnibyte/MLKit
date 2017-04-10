//
//  NeuralNetwork.swift
//  Pods
//
//  Created by Guled  on 4/6/17.
//
//

import Foundation
import Upsurge


// Feed Forward Implementation
open class NeuralNetwork {

    /// The Layers that the NeuralNetwork object contains.
    public var layers: [Layer] = []

    /// The number of layers.
    public var numberOfLayers: Int?

    /// The 'inputLayerSize' represents the number of neurons the input layer will have and the 'outputLayerSize' represents the number of output neurons the output layer will have.
    public var networkSize: (inputLayerSize: Int, outputLayerSize: Int)?


    /**
     - parameter size: See networkSize doc (attribute above).
    */
    public init(size: (Int, Int)) {

        self.networkSize = size

    }

    /**
     The addLayer method adds a new Layer to the NeuralNetwork object.

     - parameter layer: Layer object.
    */
    public func addLayer(layer: Layer) {

        self.layers.append(layer)
    }

    /**
     Given an input Matrix, the feedforward method will pass the input through the network producing a Matrix corresponding to the output of the Neural Network. The input Matrix must be of size (n, 1) (n rows and 1 column).

     - parameter input: Matrix of size (n, 1) (n rows and 1 column).
    */
    public func feedforward(input: Matrix<Float>) -> Matrix<Float> {

        var a = input

        for l in layers {
            a = l.forward(input: a)
        }

        return a
    }


    /**
     The SGD method (Stochastic Gradient Descent) trains the neural network using mini-batch stochastic
     gradient descent.

     - parameter trainingData: InputDataType object.
     - parameter epochs: Number of epochs.
     - parameter miniBatchSize: Batch size.
     - parameter eta: Learning rate.
     - parameter testData: InputDataType object. Optional.

    */
    public func SGD(trainingData: InputDataType, epochs: Int, miniBatchSize: Int, eta: Float, testData: InputDataType? = nil) {

        for i in 0..<epochs {
            var shuffledData = trainingData.data.shuffle()
            let miniBatches = stride(from: 0, to: shuffledData.count, by: miniBatchSize).map {
                Array(shuffledData[$0..<min($0 + miniBatchSize, shuffledData.count)])
            }

            for batch in miniBatches {
                var b = InputDataType(data: batch)
                self.updateMiniBatch(miniBatch: b, eta: eta)
            }
        }
    }


    /**
     The updateMiniBatch method updates the network's weights and biases by applying
     gradient descent using backpropagation to a single mini batch.

     - parameter miniBatch: InputDataType object.
     - parameter eta: Learning Rate.
    */
    public func updateMiniBatch(miniBatch: InputDataType, eta: Float) {


        for batch in miniBatch.data {
            var inputMatrix = Matrix<Float>(rows: batch.input.count, columns: 1, elements: batch.input)
            var outputMatrix = Matrix<Float>(rows: batch.target.count, columns: 1, elements: batch.target)

            self.backpropagate(input: inputMatrix, target: outputMatrix)
        }

        for layer in layers {

            layer.updateWeights(miniBatchSize: miniBatch.lengthOfTrainingData, eta: eta)

        }

    }

    /**
     The backpropagate method performs the backpropagation algorithm.

     - parameter input: Training data.
     - parameter target: Target data.

    */
    public func backpropagate(input: Matrix<Float>, target: Matrix<Float>) {

        // Feedforward
        let feedForwardOutput = feedforward(input: input)

        // Output Error
        let outputError = Matrix<Float>(rows: feedForwardOutput.rows, columns: feedForwardOutput.columns, elements: feedForwardOutput.elements - target.elements)

        // Output Layer Delta
        var delta = layers.last?.produceOuputError(cost: outputError)

        // Set the change in weights and bias for the last layer
        self.layers.last?.Δb = delta

        var activationValuesforTheSecondToLastLayer = layers[layers.count-2].activationValues

        self.layers.last?.Δw = delta! * transpose(activationValuesforTheSecondToLastLayer!)

        // Propogate error through each layer (except last)
        for i in (0..<layers.count-1).reversed() {
            delta = layers[i].propagateError(previousLayerDelta: delta!, nextLayer: layers[i+1])
        }

    }

}
