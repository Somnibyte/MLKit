import UIKit
import XCTest
import MLKit
import Upsurge

class NeuralNetworkTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerceptron() {

        var net = NeuralNet()

        net = net.initializeNet(numberOfInputNeurons: 2, numberOfHiddenLayers: 0, numberOfNeuronsInHiddenLayer: 0, numberOfOutputNeurons: 1)

        net.printNet()

        var trainedNet = NeuralNet()

        net.trainingSet = Matrix<Float>(rows: 4, columns: 3, elements: [1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0])

        net.targetOutputSet = ValueArray<Float>([0.0, 0.0, 0.0, 1.0])

        net.maxEpochs = 10

        net.targetError = 0.002

        net.learningRate = 1.0

        net.trainingType = TrainingType.PERCEPTRON

        net.activationFuncType = ActivationFunctionType.STEP

        trainedNet = net.trainNet(network: net)

        trainedNet.printNet()

        trainedNet.printTrainedNet(network: trainedNet)

        // Function to check if network output is same as target output is coming soon. For now, run test and look at console.
    }

    func testAdaline() {

        var net = NeuralNet()

        net = net.initializeNet(numberOfInputNeurons: 3, numberOfHiddenLayers: 0, numberOfNeuronsInHiddenLayer: 0, numberOfOutputNeurons: 1)

        net.printNet()

        var trainedNet = NeuralNet()

        net.trainingSet = Matrix<Float>(rows: 7, columns: 4, elements: [1.0, 0.98, 0.94, 0.95, 1.0, 0.60, 0.60, 0.85, 1.0, 0.35, 0.15, 0.15, 1.0, 0.25, 0.30, 0.98, 1.0, 0.75, 0.85, 0.91, 1.0, 0.43, 0.57, 0.87, 1.0, 0.05, 0.06, 0.01])

        net.targetOutputSet = ValueArray<Float>([0.80, 0.59, 0.23, 0.45, 0.74, 0.63, 0.10])

        net.maxEpochs = 10

        net.targetError = 0.0001

        net.learningRate = 0.5

        net.trainingType = TrainingType.ADALINE

        net.activationFuncType = ActivationFunctionType.LINEAR

        trainedNet = net.trainNet(network: net)

        trainedNet.printNet()

        trainedNet.printTrainedNet(network: trainedNet)

        // Function to check if network output is same as target output is coming soon. For now, run test and look at console.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
