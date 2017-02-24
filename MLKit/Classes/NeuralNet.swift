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

    fileprivate var _targetOutputSet: ValueArray<Float>! // The Target Output set

    public var targetOutputSet: ValueArray<Float> {

        get {
            return _targetOutputSet
        }

        set {
            _targetOutputSet = newValue
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

    fileprivate var _trainingType: TrainingType! // The Type of Training Being Used

    public var trainingType: TrainingType {

        get {
            return _trainingType
        }

        set {
            _trainingType = newValue
        }
    }


    public init() { }

    open func initializeNet(numberOfInputNeurons: Int, numberOfHiddenLayers: Int, numberOfNeuronsInHiddenLayer: Int, numberOfOutputNeurons: Int) -> NeuralNet {


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


    open func trainNet(network: NeuralNet) -> NeuralNet {

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

        default: break

        }
    }


    open func printTrainedNet (network: NeuralNet) {

        print("---------------TRAINED NEURAL NETWORK RESULTS---------------")
        switch network.trainingType {

        case .PERCEPTRON:

            var perceptron = Perceptron()
            perceptron.printTrainedNeteworkResult(trainedNetwork: network)
            break

        case .ADALINE:

            var adaline = Adaline()
            adaline.printTrainedNeteworkResult(trainedNetwork: network)
            break

        default: break

        }

    }




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
