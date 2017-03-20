//
//  NeuralNet.swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
//
// Architecture of the code inspired by Fábio M. Soares and Alan M.F Souza's implementation of a Neural Network -
// in their book Neural Network Programming in Java.

import Foundation
import Upsurge

/// The NeuralNet class defines a artificial neural network. Note that you are only allowed to have 1 hidden layer.
public class NeuralNet {

    public var estimatedOutputAsArray: [Float] = []

    /// Estimated output after training as a Matrix Object
    public var estimatedOutputAsMatrix: Matrix<Float>!

    /// The Input Layer
    public var inputLayer: InputLayer

    /// List of Hidden Layers
    public var listOfHiddenLayers: [HiddenLayer] = []

    /// The Output Layer
    public var outputLayer: OutputLayer

    /// The Number of Hidden Layers
    public var numberOfHiddenLayers: Int

    /// Your Training Set
    public var trainingSet: Matrix<Float>?

    /// The Target Output set (Generally Used for Single Layer Perceptron & Adaline)
    public var targetOutputSet: ValueArray<Float>!

    /// The Target Output Matrix
    public var targetOutputMatrix: Matrix<Float>!

    /// Max Epoch (Stopping condition for training)
    public var maxEpochs: Int!

    /// The Learning Rate
    public var learningRate: Float!

    /// The Target Error
    public var targetError: Float!

    /// The Training Error
    public var trainingError: Float!

    /// A List of MSE values
    public var meanSquaredErrorList: [Float] = []

    /// The Type of Activation Function Being Used
    public var activationFuncType: ActivationFunctionType!

    /// The Type of Activation Being Used for the Output Layer
    public var activationFuncTypeOfOutputLayer: ActivationFunctionType!

    /// The Type of Training Being Used
    public var trainingType: TrainingType!

    /// Stores the mean of the error between two or more neurons
    public var errorMean: Float!

    /**
     The initializeNet method allows you to initialize a Neural Net Object.

     - parameter numberOfInputNeurons: Number of neurons for input layer.
     - parameter numberOfHiddenLayers: Number of hidden layers. Default is 1. You cannot exceed 1 hidden layer. More on this in the docs.
     - parameter numberOfNeuronsInHiddenLayer: Number of neurons in hidden layer.
     - parameter  numberOfOutputNeurons: Numebr of output neurons.

     - returns: A Neural Net Object.
     */
    public init() {
        inputLayer = InputLayer()
        outputLayer = OutputLayer()
        numberOfHiddenLayers = 0
    }

    public init(numberOfInputNeurons: Int, hiddenLayers: [Int], numberOfOutputNeurons: Int) {

        // Initialize Input Layer
        inputLayer = InputLayer()
        inputLayer.numberOfNeuronsInLayer = numberOfInputNeurons

        // Initialize Hidden Layers
        self.numberOfHiddenLayers = hiddenLayers.count

        for i in 0..<numberOfHiddenLayers {
            var hiddenLayer = HiddenLayer()
            hiddenLayer.numberOfNeuronsInLayer = hiddenLayers[i]
            listOfHiddenLayers.append(hiddenLayer)
        }

        // Initialize OuptutLayer
        outputLayer = OutputLayer()
        outputLayer.numberOfNeuronsInLayer = numberOfOutputNeurons

        inputLayer = inputLayer.initializeLayer(inputLayer: inputLayer)

        for hiddenLayer in listOfHiddenLayers {
            listOfHiddenLayers = hiddenLayer.initializeLayer(hiddenLayer: hiddenLayer, listOfHiddenLayers: listOfHiddenLayers, inputLayer: inputLayer, outputLayer: outputLayer)
        }

        outputLayer = outputLayer.initializeLayer(outLayer: outputLayer)
    }

    // MARK: - Public Methods

    /**
     The forward method allows a NeuralNet object to pass in inputs (corresponding to the number of input layers in your NueralNet Object) and recieve a list of output values (depends on the number of output layer neurons available).

     - parameter input: An array of Float values. NOTE: Don't forget to make the first input value a '1' (this is your bias value).

     - returns: A list of Float values corresponding to the output of your NeuralNet object.
     */
    public func forward(input: [Float]) -> [Float] {
        return forwardProcess(network: self, input:input)
    }

    /**
     The trainNet method trains the Neural Network with the methods available (perceptron, adaline, and backpropagation). It is advised that you use this method for supervised learning.

     - parameter network: A Neural Net Object.

     - returns: A Neural Net Object.
     */
    public func trainNet() throws -> NeuralNet {
        return self.trainingType.trainingFunction.train(network: self)
    }

    /**
     The printTrainedNet prints a Neural Net objects weights. Should be used to evaluate the progress of your trained Neural Network.
     */
    public func printTrainedNet(network: NeuralNet) {

        print("---------------TRAINED NEURAL NETWORK RESULTS---------------")
        switch network.trainingType! {
        case .perceptron:

            var perceptron = Perceptron()
            perceptron.printTrainedNetwork(trainedNetwork: network, singleLayer: true)
            break

        case .adaline:

            var adaline = Adaline()
            adaline.printTrainedNetwork(trainedNetwork: network, singleLayer: true)
            break

        case .backpropagation:

            var backpropagation = BackPropagation()
            backpropagation.printTrainedNetwork(trainedNetwork: network, singleLayer: false)
            break

        default: break

        }

    }

    /**
     The printTrainedNet prints a Neural Net objects weights (use for debugging and or checking weights).
     */
    public func printNet() {

        print("---------------WEIGHTS FOR EACH LAYER---------------")
        inputLayer.printLayer(layer: inputLayer)
        print()
        for hiddenLayer in listOfHiddenLayers {
            hiddenLayer.printLayer(listOfHiddenLayers: listOfHiddenLayers)
        }
        print()
        outputLayer.printLayer(layer: outputLayer)
        print("\n")
    }

    // MARK: - Private Methods
    private func forwardProcess(network: NeuralNet, input: [Float]) -> [Float] {

        var listOfHiddenLayers: [HiddenLayer] = []

        // Obtain all hidden layers in the network
        listOfHiddenLayers = network.listOfHiddenLayers

        // For each hidden layer ...
        for (hiddenLayer_i, hiddenLayer) in listOfHiddenLayers.enumerated() {

            // Obtain the number of neurons in the layer
            var numberOfNeuronsInLayer = hiddenLayer.numberOfNeuronsInLayer

            // For each neuron ...
            for neuron in hiddenLayer.listOfNeurons {

                var netValueOut: Float = 0.0 // Net Value (activation value)

                if neuron.weightsComingIn.count <= 0 {
                    // Bias
                    neuron.outputValue = 1.0
                    continue
                }

                var netValue: Float = 0.0 // Activation Value

                // Sum of the weights combined with the inputs
                for layer_j in 0..<(numberOfNeuronsInLayer - 1) {
                    var hiddenWeightIn = neuron.weightsComingIn[layer_j]
                    netValue += hiddenWeightIn * input[layer_j]
                }

                // Activation function calculates the neurons output
                netValueOut = try! NNOperations.activationFunc(fncType: network.activationFuncType, value: netValue)

                // Set the neurons output
                neuron.outputValue = netValue

            }

            // For each of the nuerons in the output layer ...
            for var outLayer_i in 0..<network.outputLayer.numberOfNeuronsInLayer {

                var netValue: Float = 0.0 // Sum of neurons outputs (with weights) from the previous (hidden) layer
                var netValueOut: Float = 0.0 // Final activation value

                // For each neuron in the hidden layer, calculate the netValue
                for neuron in hiddenLayer.listOfNeurons {
                    var hiddenWeightOut = neuron.weightsGoingOut[outLayer_i]
                    netValue += hiddenWeightOut * neuron.outputValue
                }

                // Use the activation function to calculate the activation of the output neuron(s)
                netValueOut = try! NNOperations.activationFunc(fncType: network.activationFuncTypeOfOutputLayer, value: netValue)

                // Set the output neurons output/activation
                network.outputLayer.listOfNeurons[outLayer_i].outputValue = netValueOut

            }

            // Set the hidden layers of the network with the newly adjusted neurons
            network.listOfHiddenLayers[hiddenLayer_i].listOfNeurons = hiddenLayer.listOfNeurons
        }

        var finalOutputSet: [Float] = []

        for neuron in self.outputLayer.listOfNeurons {
            finalOutputSet.append(neuron.outputValue)
        }

        return finalOutputSet
    }

}
