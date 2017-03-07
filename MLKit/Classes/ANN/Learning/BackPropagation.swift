//
//  BackPropogation.swift
//  Pods
//
//  Created by Guled  on 2/27/17.
//
//

import Foundation
import Upsurge

public class BackPropagation: Training {

    var meanSquaredError: Float!

    open func train(network: NeuralNet) -> NeuralNet {


        /// Network (Xcode won't stop complaining about 'let' variable network
        var network = network

        /// Set Initial Epoch
        var epoch: Int = 0

        /// Set MSE
        self.meanSquaredError = 1.0

        var rows = network.trainingSet.rows

        /// Start training
        while self.meanSquaredError > network.targetError {

            // Exit if done with training
            if epoch >= network.maxEpochs { break }

            var sumErrors: Float = 0.0

            for var i in 0..<rows {

                network = forward(network: network, row: i)

                network = backpropagation(network: network, row: i)

                sumErrors += network.errorMean
            }


            self.meanSquaredError = sumErrors / Float(rows)

            print(self.meanSquaredError)

            epoch += 1
        }

        return network
    }

    // TODO: Add ability for more hidden layers (currently allows for only 1 hidden layer)
    // TODO: Use Matrix Operations rather than loops for performance.
    private func forward(network: NeuralNet, row: Int) -> NeuralNet {

        var listOfHiddenLayers: [HiddenLayer] = []


        // Obtain all hidden layers in the network
        listOfHiddenLayers = network.listOfHiddenLayers

        var estimatedOutput: Float = 0.0
        var actualOutput: Float = 0.0
        var sumError: Float = 0.0

        // Check if there are any hidden layers in the network
        if listOfHiddenLayers.count > 0 {

            var hiddenLayer_i = 0

            // For each hidden layer ...
            for hiddenLayer in listOfHiddenLayers {


                // Obtain the number of neurons in the layer
                var numberOfNeuronsInLayer = hiddenLayer.numberOfNueronsInLayer

                // For each neuron ...
                for neuron in hiddenLayer.listOfNeurons {

                    var netValueOut: Float = 0.0 // Net Value (activation value)

                    // If the neurons weights (coming into the neuron) are greater than 0 ...
                    if neuron.weightsComingIn.count > 0 {

                        var netValue: Float = 0.0 // Activation Value


                        // Sum of the weights combined with the inputs
                        for var layer_j in 0..<(numberOfNeuronsInLayer - 1) {
                            var hiddenWeightIn = neuron.weightsComingIn[layer_j]
                            netValue += hiddenWeightIn * network.trainingSet[row, layer_j]
                        }

                        // Activation function calculates the neurons output
                        netValueOut = try! NNOperations.activationFunc(fncType: network.activationFuncType, value: netValue)

                        // Set the neurons output
                        neuron.outputValue = netValue

                    } else {

                        // Bias
                        neuron.outputValue = 1.0
                    }

                }


                // For each of the nuerons in the output layer ...
                for var outLayer_i in 0..<network.outputLayer.numberOfNueronsInLayer {

                    var netValue: Float = 0.0 // Sum of neurons outputs (with weights) from the previous (hidden) layer
                    var netValueOut: Float = 0.0 // Final activation value

                    // For each neuron in the hidden layer, calculate the netValue
                    for neuron in hiddenLayer.listOfNeurons {
                        var hiddenWeightOut = neuron.weightsGoingOut[outLayer_i]
                        netValue += hiddenWeightOut * neuron.outputValue
                    }

                    // Use the activation function to calculate the activation of the output neuron(s)
                    netValueOut = try! NNOperations.activationFunc(fncType: network.activationFuncTypeOutputLayer, value: netValue)

                    // Set the output neurons output/activation
                    network.outputLayer.listOfNeurons[outLayer_i].outputValue = netValueOut


                    // Error Calculation
                    estimatedOutput = netValueOut
                    actualOutput = network.targetOutputMatrix[row, outLayer_i]
                    var error = actualOutput - estimatedOutput
                    network.outputLayer.listOfNeurons[outLayer_i].error = error
                    sumError += pow(error, 2.0)
                }


                // Error Mean
                var errorMean: Float = sumError / Float(network.outputLayer.numberOfNueronsInLayer)

                network.errorMean = errorMean

                // Set the hidden layers of the network with the newly adjusted neurons
                network.listOfHiddenLayers[hiddenLayer_i].listOfNeurons = hiddenLayer.listOfNeurons

                hiddenLayer_i += 1
            }
        }


        return network
    }


    /**
     The backpropagation method performs the backpropagation algorithm to a NeuralNet object. Note that, currently, this algorithm works with 1 hidden layer. At the moment you cannot exceed this amount.

     - parameter network: A Neural Net Object.
     - parameter row: Integer representing row of training data.

     - returns: A Neural Net Object.
     */
    private func backpropagation(network: NeuralNet, row: Int) -> NeuralNet {


        var outputLayer: [Neuron] = []
        outputLayer = network.outputLayer.listOfNeurons

        var hiddenLayer: [Neuron] = []
        hiddenLayer = network.listOfHiddenLayers[0].listOfNeurons


        var error: Float = 0.0
        var netValue: Float = 0.0
        var sensibility: Float = 0.0


        // Calculate sensibility (error signal) for output layer
        for neuron in outputLayer {
            error = neuron.error
            netValue = neuron.outputValue
            sensibility = try! NNOperations.derivativeFunc(fncType: network.activationFuncTypeOutputLayer, value: netValue) * error

            // Set the neurons sensibility/error signal
            neuron.sensibility = sensibility
        }


        // Calculate the sensibility for the hidden layer
        for neuron in hiddenLayer {

            sensibility = 0.0

            if neuron.weightsComingIn.count > 0 { // Exclude bias

                var listOfWeightsGoingOut: ValueArray<Float> = ValueArray<Float>()

                listOfWeightsGoingOut = neuron.weightsGoingOut

                var tempSensibility: Float = 0.0

                var weight_i: Int = 0

                for weight in listOfWeightsGoingOut {

                    tempSensibility += (weight * outputLayer[weight_i].sensibility)
                    weight_i += 1
                }

                sensibility = try! NNOperations.derivativeFunc(fncType: network.activationFuncType, value: neuron.outputValue) * tempSensibility

                neuron.sensibility = sensibility

            }

        }

        // fix weights (teach) [output layer to hidden layer]
        for outLayer_i in 0..<network.outputLayer.numberOfNueronsInLayer {

            for neuron in hiddenLayer {

                var newWeight = neuron.weightsGoingOut[outLayer_i] + (network.learningRate * outputLayer[outLayer_i].sensibility * neuron.outputValue)
                neuron.weightsGoingOut[outLayer_i] = newWeight
            }

        }


        //fix weights (teach) [hidden layer to input layer]
        for neuron in hiddenLayer {

            var hiddenLayerInputWeights: ValueArray<Float> = ValueArray<Float>()
            hiddenLayerInputWeights = neuron.weightsComingIn

            if hiddenLayerInputWeights.count > 0 {

                var hidden_i: Int = 0
                var newWeight: Float = 0.0

                for var i in 0..<network.inputLayer.numberOfNueronsInLayer {
                    newWeight = hiddenLayerInputWeights[hidden_i] + (network.learningRate * neuron.sensibility * network.trainingSet[row, i])

                    neuron.weightsComingIn[hidden_i] = newWeight
                }


            }

        }

        network.listOfHiddenLayers[0].listOfNeurons = hiddenLayer

        return network
    }

}
