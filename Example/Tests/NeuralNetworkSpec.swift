//
//  NeuralNetworkSpec.swift
//  MLKit
//
//  Created by Guled  on 3/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Upsurge
import MachineLearningKit
import Quick
import Nimble

class NeuralNetworkSpec: QuickSpec {

    override func spec() {

        it("Should be able to run a simple XOR example using a single layer Perceptron architecture.") {

            print("\n")
            print("XOR perceptron TEST \n")

            let net = NeuralNet(numberOfInputNeurons: 2, numberOfHiddenLayers: 0, numberOfNeuronsInHiddenLayer: 0, numberOfOutputNeurons: 1)
            net.printNet()

            net.trainingSet = Matrix<Float>(rows: 4, columns: 3, elements: [1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0])

            net.targetOutputSet = ValueArray<Float>([0.0, 0.0, 0.0, 1.0])

            net.maxEpochs = 10

            net.targetError = 0.002

            net.learningRate = 1.0

            net.trainingType = TrainingType.perceptron

            net.activationFuncType = ActivationFunctionType.step

            let trainedNet = try! net.trainNet()

            trainedNet.printNet()

            trainedNet.printTrainedNet(network: trainedNet)

            var actualOutput: [Float] = []

            for val in trainedNet.targetOutputSet {
                actualOutput.append(val)
            }

            expect(trainedNet.estimatedOutputAsArray).to(equal(actualOutput))

        }

        it("Should be able to run a simple example using a single layer Adaline architecture.") {

            let net = NeuralNet(numberOfInputNeurons: 3, numberOfHiddenLayers: 0, numberOfNeuronsInHiddenLayer: 0, numberOfOutputNeurons: 1)

            net.printNet()

            net.trainingSet = Matrix<Float>(rows: 7, columns: 4, elements: [1.0, 0.98, 0.94, 0.95, 1.0, 0.60, 0.60, 0.85, 1.0, 0.35, 0.15, 0.15, 1.0, 0.25, 0.30, 0.98, 1.0, 0.75, 0.85, 0.91, 1.0, 0.43, 0.57, 0.87, 1.0, 0.05, 0.06, 0.01])

            net.targetOutputSet = ValueArray<Float>([0.80, 0.59, 0.23, 0.45, 0.74, 0.63, 0.10])

            net.maxEpochs = 10

            net.targetError = 0.0001

            net.learningRate = 0.5

            net.trainingType = TrainingType.adaline

            net.activationFuncType = ActivationFunctionType.linear

            let trainedNet = try! net.trainNet()

            trainedNet.printNet()

            trainedNet.printTrainedNet(network: trainedNet)

            var actualOutput: [Double] = []

            for val in trainedNet.targetOutputSet {
                actualOutput.append(Double(val))

            }

            var estimatedOutputAsDouble: [Double] = []

            for val in trainedNet.estimatedOutputAsArray {
                estimatedOutputAsDouble.append(Double(val))
            }

            expect(estimatedOutputAsDouble).to(beCloseTo(actualOutput as [Double], within:1.0))
        }

        it("Should be able to run a simple example using a BackPropagation architecture.") {

            let net = NeuralNet.init(numberOfInputNeurons: 2, numberOfHiddenLayers: 1, numberOfNeuronsInHiddenLayer: 3, numberOfOutputNeurons: 2)

            print("---------------------backpropagation INIT---------------------")

            net.printNet()

            net.trainingSet = Matrix<Float>(rows: 10, columns: 3, elements: [1.0, 1.0, 0.73,
                                                                             1.0, 1.0, 0.81,
                                                                             1.0, 1.0, 0.86,
                                                                             1.0, 1.0, 0.95,
                                                                             1.0, 0.0, 0.45,
                                                                             1.0, 1.0, 0.70,
                                                                             1.0, 0.0, 0.51,
                                                                             1.0, 1.0, 0.89,
                                                                             1.0, 1.0, 0.79,
                                                                             1.0, 0.0, 0.54])

            net.targetOutputMatrix = Matrix<Float>(rows: 10, columns: 2, elements: [1.0, 0.0,
                                                                                    1.0, 0.0,
                                                                                    1.0, 0.0,
                                                                                    1.0, 0.0,
                                                                                    1.0, 0.0,
                                                                                    0.0, 1.0,
                                                                                    0.0, 1.0,
                                                                                    0.0, 1.0,
                                                                                    0.0, 1.0,
                                                                                    0.0, 1.0])

            net.maxEpochs = 1000

            net.targetError = 0.002

            net.learningRate = 0.1

            net.trainingType = .backpropagation

            net.activationFuncType = ActivationFunctionType.siglog

            net.activationFuncTypeOfOutputLayer = .linear

            let trainedNet = try! net.trainNet()

            trainedNet.printNet()

            trainedNet.printTrainedNet(network: trainedNet)

        }

    }

}
