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


open class NeuralNet {

    fileprivate var _inputLayer: InputLayer! // The Input Layer

    public var inputLayer: InputLayer {

        get {
            return _inputLayer
        }

        set {
            _inputLayer = newValue
        }
    }

    fileprivate var _hiddenLayer: HiddenLayer! // Hidden Layer

    public var hiddenLayer: HiddenLayer {

        get {
            return _hiddenLayer
        }

        set {
            _hiddenLayer = newValue
        }
    }

    fileprivate var _listOfHiddenLayers: [HiddenLayer]! // List of Hidden Layers

    public var listOfHiddenLayers: [HiddenLayer] {

        get {
            return _listOfHiddenLayers
        }

        set {
            _listOfHiddenLayers = newValue
        }

    }

    fileprivate var _outputLayer: OutputLayer! // The Output Layer

    public var outputLayer: OutputLayer {

        get {
            return _outputLayer
        }

        set {
            _outputLayer = newValue
        }

    }

    fileprivate var _numberOfHiddenLayers: Int! // The Number of Hidden Layers

    public var numberOfHiddenLayers: Int {

        get {
            return _numberOfHiddenLayers
        }

        set {
            _numberOfHiddenLayers = newValue
        }

    }

    fileprivate var _trainingSet: Matrix<Float>! // Your Training Set

    public var trainingSet: Matrix<Float> {

        get {
            return _trainingSet
        }

        set {
            _trainingSet = newValue
        }

    }

    fileprivate var _targetOutputSet: ValueArray<Float>! // The Target Output set (Generally Used for Single Layer Perceptron & Adaline)

    public var targetOutputSet: ValueArray<Float> {

        get {
            return _targetOutputSet
        }

        set {
            _targetOutputSet = newValue
        }

    }

    fileprivate var _targetOutputMatrix: Matrix<Float>! // The Target Output Matrix

    public var targetOutputMatrix: Matrix<Float> {

        get {
            return _targetOutputMatrix
        }

        set {
            _targetOutputMatrix = newValue
        }

    }

    fileprivate var _maxEpochs: Int! // Max Epoch (Stopping condition for training)

    public var maxEpochs: Int {

        get {
            return _maxEpochs
        }

        set {
            _maxEpochs = newValue
        }
    }

    fileprivate var _learningRate: Float! // The Learning Rate

    public var learningRate: Float {

        get {
            return _learningRate
        }

        set {
            _learningRate = newValue
        }
    }

    fileprivate var _targetError: Float! // The Target Error

    public var targetError: Float {

        get {
            return _targetError
        }

        set {
            _targetError = newValue
        }
    }

    fileprivate var _trainingError: Float! // The Training Error

    public var trainingError: Float {

        get {
            return _trainingError
        }

        set {
            _trainingError = newValue
        }
    }

    fileprivate var _meanSquaredErrorList: [Float] = [] // A List of MSE values

    public var meanSquaredErrorList: [Float] {

        get {
            return _meanSquaredErrorList
        }

        set {
            _meanSquaredErrorList = newValue
        }
    }

    fileprivate var _activationFuncType: ActivationFunctionType! // The Type of Activation Function Being Used

    public var activationFuncType: ActivationFunctionType {

        get {
            return _activationFuncType
        }

        set {
            _activationFuncType = newValue
        }
    }

    fileprivate var _activationFuncTypeOfOuputLayer: ActivationFunctionType! // The Type of Activation Being Used for the Output Layer

    public var activationFuncTypeOutputLayer: ActivationFunctionType {

        get {
            return _activationFuncTypeOfOuputLayer
        }

        set {
            _activationFuncTypeOfOuputLayer = newValue
        }
    }


    fileprivate var _trainingType: TrainingType! // The Type of Training Being Used

    public var trainingType: TrainingType {

        get {
            return _trainingType
        }

        set {
            _trainingType = newValue
        }
    }

    fileprivate var _errorMean: Float! // Stores the mean of the error between two or more neurons

    public var errorMean: Float {

        get {
            return _errorMean
        }

        set {
            _errorMean = newValue
        }
    }


    public init() { }


    /**
     The initializeNet method allows you to initialize a Neural Net Object.

     - parameter numberOfInputNeurons: Number of neurons for input layer.
     - parameter numberOfHiddenLayers: Number of hidden layers. Default is 1. You cannot exceed 1 hidden layer. More on this in the docs.
     - parameter numberOfNeuronsInHiddenLayer: Number of neurons in hidden layer.
     - parameter  numberOfOutputNeurons: Numebr of output neurons.

     - returns: A Neural Net Object
     */
    open func initializeNet(numberOfInputNeurons: Int, numberOfHiddenLayers: Int = 1, numberOfNeuronsInHiddenLayer: Int, numberOfOutputNeurons: Int) -> NeuralNet {


        // Initialize Input Layer
        inputLayer = InputLayer()
        inputLayer.numberOfNueronsInLayer = numberOfInputNeurons


        // Initialize Hidden Layer
        listOfHiddenLayers = []
        hiddenLayer = HiddenLayer()

        for var i in 0..<numberOfHiddenLayers {

            hiddenLayer = HiddenLayer()
            hiddenLayer.numberOfNueronsInLayer = numberOfNeuronsInHiddenLayer
            listOfHiddenLayers.append(hiddenLayer)

        }

        // Initialize OuptutLayer
        outputLayer = OutputLayer()
        outputLayer.numberOfNueronsInLayer = numberOfOutputNeurons

        inputLayer = inputLayer.initializeLayer(inputLayer: inputLayer)

        if numberOfHiddenLayers > 0 {

            listOfHiddenLayers = hiddenLayer.initializeLayer(hiddenLayer: hiddenLayer, listOfHiddenLayers: listOfHiddenLayers, inputLayer: inputLayer, outputLayer: outputLayer)
        }

        outputLayer = outputLayer.initializeLayer(outLayer: outputLayer)

        // Create Neural Network
        var newNeuralNetwork = NeuralNet()
        newNeuralNetwork.inputLayer = inputLayer
        newNeuralNetwork.outputLayer = outputLayer
        newNeuralNetwork.hiddenLayer = hiddenLayer
        newNeuralNetwork.listOfHiddenLayers = listOfHiddenLayers
        newNeuralNetwork.numberOfHiddenLayers = numberOfHiddenLayers

        return newNeuralNetwork
    }


    /**
     The trainNet method trains the Neural Network with the methods available (PERCEPTRON, ADALINE, and BACKPROPAGATION).

     - parameter network: A Neural Net Object.

     - returns: A Neural Net Object
     */
    open func trainNet(network: NeuralNet) throws -> NeuralNet {

        var trainedNetwork = NeuralNet()

        switch network.trainingType {

        case .PERCEPTRON:

            var perceptron = Perceptron()
            trainedNetwork = perceptron.train(network: network)
            return trainedNetwork

        case .ADALINE:

            var adaline = Adaline()
            trainedNetwork = adaline.train(network: network)
            return trainedNetwork

        case .BACKPROPAGATION:

            var backpropagation = BackPropagation()
            trainedNetwork = backpropagation.train(network: network)
            return trainedNetwork

        default:
            throw MachineLearningError.invalidInput
        }
    }

    /**
     The printTrainedNet prints a Neural Net objects weights.
     */
    open func printTrainedNet (network: NeuralNet) {

        print("---------------TRAINED NEURAL NETWORK RESULTS---------------")
        switch network.trainingType {

        case .PERCEPTRON:

            var perceptron = Perceptron()
            perceptron.printTrainedNetwork(trainedNetwork: network, singleLayer: true)
            break

        case .ADALINE:

            var adaline = Adaline()
            adaline.printTrainedNetwork(trainedNetwork: network, singleLayer: true)
            break

        case .BACKPROPAGATION:

            var backpropagation = BackPropagation()
            backpropagation.printTrainedNetwork(trainedNetwork: network, singleLayer: false)
            break

        default: break

        }

    }

    /**
     The printTrainedNet prints a Neural Net objects weights (use for debugging and or checking weights).
     */
    open func printNet() {

         print("---------------WEIGHTS FOR EACH LAYER---------------")
        inputLayer.printLayer(layer: inputLayer)
        print()
        hiddenLayer.printLayer(listOfHiddenLayers: listOfHiddenLayers)
        print()
        outputLayer.printLayer(layer: outputLayer)
        print("\n")
    }
}
