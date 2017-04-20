//
//  Layer.swift
//  Pods
//
//  Created by Guled  on 4/6/17.
//
//

import Foundation
import Upsurge

open class Layer {

    /// Ex: If layerSize is (2,3) then the layer has 2 neurons and each neuron has 3 outgoing synapses. (BIAS ALREADY INCLUDED)
    var layerSize: (numberOfNeurons: Int, outgoingSynapsesForEachNeuron: Int)?

    /// Matrix of bias values.
    public var bias: Matrix<Float>?

    /// Matrix of weight values.
    public var weights: Matrix<Float>?

    /// Matrix representing values that are passed as input to the neurons of the current layer.
    public var input: Matrix<Float>?

    /// Matrix representing the aggregate of weights & inputs to the layer for each neuron.
    public var zValues: Matrix<Float>?

    /// Matrix representing the activation values for each neuron of the layer.
    public var activationValues: Matrix<Float>?

    /// Matrix representing the amount of change for the weights of each particular neuron in the layer. The matrix is used to update the weights of a layer (the weights within a particular layers neurons are subtracted from this change during stochastic gradient descent algorithm).
    public var Δw: Matrix<Float>?

    /// Matrix representing the amount of change for the bias value of each particular neuron in the layer. The matrix is used to update the biases of a layer (the biases within a particular layers neurons are subtracted from this change during stochastic gradient descent algorithm).
    public var Δb: Matrix<Float>?

    /// The activationType represents the activation function that this particular layer will use. This enumeration will allow you to choose activation functions (and their derivatives) in an organized manner.
    public var activationType: ActivationFunctionType?


    public init(size: (numberOfNeurons: Int, outgoingSynapsesForEachNeuron: Int), activationType: ActivationFunctionType) {

        self.layerSize = size

        self.bias = Matrix<Float>(rows: size.outgoingSynapsesForEachNeuron, columns: 1, elements: ValueArray<Float>(count: size.outgoingSynapsesForEachNeuron, repeatedValue: 1.0))

        self.weights = generateRandomWeights()

        self.Δb = Matrix<Float>([Array<Float>(repeating: 0.0, count: (self.bias?.elements.count)!)])

        self.Δw = Matrix<Float>([Array<Float>(repeating: 0.0, count: (self.weights?.elements.count)!)])

        self.activationType = activationType
    }


    /**
     Manipulate the weights values of a particular Layer object.

     - parameter newWeights: Weights as a matrix. Shape (rows and columns) must be equivalent to the weights of the Layer object being manipulated.

     */
    public func editWeights(newWeights: Matrix<Float>) throws {

        if let currentWeights = self.weights {
            if newWeights.rows != currentWeights.rows && newWeights.columns != currentWeights.columns {
                throw MachineLearningError.invalidInput
            }
        }

        self.weights = newWeights
    }


    /**
     Manipulate the bias values of a particular Layer object.

     - parameter newBias: Bias as a matrix. Shape (rows and columns) must be equivalent to the bias of the Layer object being manipulated.

     */
    public func editBias(newBias: Matrix<Float>) throws {

        if let currentBias = self.bias {
            if newBias.rows != currentBias.rows && newBias.columns != currentBias.columns {
                throw MachineLearningError.invalidInput
            }
        }

        self.bias = newBias
    }


    /**
     The forward method passes input into the layers neurons and produces an output matrix. The method saves the input into the Layer objects 'input' atrribute. The method also saves the activation and net value of each neuron into the 'activationValues' and 'zValues' attributes.

     - parameter input: Matrix of input values. EX: If the shape of your layer is (2,1), your input should be of shape (2,1).

     - returns: Output in the form of a matrix (Activation values).
     */
    public func forward(input: Matrix<Float>) -> Matrix<Float> {

        var a = input

        self.input = input

        a = (self.weights! * a)

        a = Matrix<Float>(rows: a.rows, columns: a.columns, elements: a.elements + self.bias!.elements)

        self.zValues = a

        a = Matrix<Float>(rows: a.rows, columns: a.columns, elements: a.elements.map((activationType?.activate())!))

        self.activationValues = a

        return a
    }

    /**
     The produceOutputError method calculates the signal or error value that the output layer produces. This is used for the backpropagation algorithm. Only the last layer is able to utilize this method.

     - parameter cost: The cost represents the subtraction of the expected output by the target output.

     - returns: The delta/signal of the last layer.
     */
    public func produceOuputError(cost: Matrix<Float>) -> Matrix<Float> {

        var z = self.zValues

        z = Matrix<Float>(rows: (z?.rows)!, columns: (z?.columns)!, elements:ValueArray<Float>(z!.elements.map((activationType?.derivative())!)))

        var sigmaPrime = z

        var Δ = cost * sigmaPrime!

        return Δ
    }

    /**
     The propagateError method is used within the backpropagation algorithm in a NeuralNetwork object in order to propagate the error signal to the previous layers starting from the second to last layer.
     - parameter previousLayerDelta: The delta/error signal values of the previous layer.
     - parameter nextLayer: The next layer (Layer object).

     - returns: A Matrix containing the error signal of the previous layer.
     */
    public func propagateError(previousLayerDelta: Matrix<Float>, nextLayer: Layer) -> Matrix <Float> {

        // Compute the current layers δ value.
        var nextLayerWeightTranspose = transpose(nextLayer.weights!)

        var deltaMultipliedBywT =  nextLayerWeightTranspose * previousLayerDelta

        var sigmaPrime = Matrix<Float>(rows: (self.zValues?.rows)!, columns: (self.zValues?.columns)!, elements: ValueArray(self.zValues!.elements.map((activationType?.derivative())!)))

        var currentLayerDelta =  Matrix<Float>(rows: deltaMultipliedBywT.rows, columns: deltaMultipliedBywT.columns, elements:  ValueArray(deltaMultipliedBywT.elements * sigmaPrime.elements))

        // Update the current layers weights
        var inputTranspose = transpose(self.input!)

        var updatedWeights = currentLayerDelta * inputTranspose

        self.Δw = updatedWeights

        // Update the current layers bias
        self.Δb = currentLayerDelta

        return currentLayerDelta
    }

    /**
     The updateWeights method updates the weight and bias values of a Layer object.

     - parameter miniBatchSize: Mini-Batch size.
     - parameter eta: Learning rate.

     */
    public func updateWeights(miniBatchSize: Int, eta: Float) {

        var learningRate = eta/Float(miniBatchSize)

        var changeInWeights = learningRate * self.Δw!

        var changedBiases = learningRate * self.Δb!

        self.weights = self.weights! - changeInWeights

        self.bias = self.bias! - changedBiases
    }

    /// Generates random bias values for a particular Layer object. Note: When you instantiate a layer, the bias values are all 1 by default.
    public func generateRandomBiases() -> Matrix<Float> {

        var biasValues: [Float] = []

        for i in 0..<layerSize!.outgoingSynapsesForEachNeuron {
            var biasValue = generateRandomNumber()
            biasValues.append(biasValue)
        }

        return Matrix<Float>(rows: (layerSize?.outgoingSynapsesForEachNeuron)!, columns: 1, elements: ValueArray<Float>(biasValues))
    }

    /// Generates random weight values for a particular Layer object.
    private func generateRandomWeights() -> Matrix<Float> {
        var weightValues: [Float] = []

        for i in 0..<(layerSize!.numberOfNeurons * layerSize!.outgoingSynapsesForEachNeuron) {
            var weightValue = generateRandomNumber()

            weightValues.append(weightValue)
        }


        return Matrix<Float>(rows: layerSize!.outgoingSynapsesForEachNeuron, columns: layerSize!.numberOfNeurons, elements: ValueArray<Float>(weightValues))
    }

    /**
     The generateRandomNumber generates a random number (normal distribution using Box-Muller tranform).

     - returns: A random number (normal distribution).
     */
    private func generateRandomNumber() -> Float {
        let u = Float(arc4random()) / Float(UINT32_MAX)
        let v = Float(arc4random()) / Float(UINT32_MAX)
        let randomNum = sqrt( -2 * log(u) ) * cos( Float(2) * Float(M_PI) * v )

        return randomNum
    }

}
