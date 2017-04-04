//: Playground - noun: a place where people can play

import UIKit
import Upsurge

// Feed Forward Implementation 
class NeuralNetwork {

    public var numberOfLayers: Int?
    public var networkSize: [Int]?
    public var bias: [Matrix<Float>]?
    public var weights: [Matrix<Float>]?

    init(size:[Int]){

        self.numberOfLayers = size.count

        self.networkSize = size

        self.bias = generateRandomBiases()

        self.weights = generateRandomWeights()
    }

    // TODO: ERROR CHECKING
    func generateRandomBiases() -> [Matrix<Float>] {
        var biases: [Matrix<Float>] = []

        for i in stride(from: 1, to: networkSize!.count, by: 1) {

            var bias: [Float] = []
            var length: Int = networkSize![i]

            for j in 0..<networkSize![i] {
                bias.append(generateRandomNumber())
            }

            var biasAsValueArray = ValueArray(bias)
            var biasAsMatrix = Matrix<Float>(rows: length, columns: 1, elements: biasAsValueArray)
            biases.append(biasAsMatrix)
        }

        return biases
    }

    public func feedforward(activation:Matrix<Float>) -> Matrix<Float> {

        var a = activation

        for (b, w) in zip(self.bias!, self.weights!) {
            a = (w * a) + b
            a.elements.map(fncSigLog)
        }

        return a
    }

    func generateRandomWeights() -> [Matrix<Float>]{
        var pairs = zip(Array(networkSize![0...networkSize!.count-2]), Array(networkSize![1...networkSize!.count-1]))
        var arrayOfWeights: [Matrix<Float>] = []

        for pair in pairs {
            var numberOfWeightsInMatrix = pair.0 * pair.1
            var elements:[Float] = []

            for i in 1...numberOfWeightsInMatrix  {
                elements.append(generateRandomNumber())
            }

            var weights = Matrix<Float>(rows:pair.1, columns:pair.0, elements: elements)
            arrayOfWeights.append(weights)
        }


        return arrayOfWeights
    }

    func generateRandomNumber() -> Float{
        let u = Float(arc4random()) / Float(UINT32_MAX)
        let v = Float(arc4random()) / Float(UINT32_MAX)
        let randomNum = sqrt(-2*log(u))*cos(Float(2) * Float(M_PI) * v)

        return randomNum
    }

    public func fncSigLog(val: Float) -> Float {
        return 1.0 / (1.0 + exp(-val))
    }

}

var nn = NeuralNetwork(size: [2,3,1])
var a = Matrix<Float>(rows: 2, columns: 1, elements: [1.0,1.0])
print(nn.feedforward(activation: a))

/*
var bias = nn.bias
var weights = nn.weights
var a = Matrix<Float>(rows: 2, columns: 1, elements: [1.0,1.0])

var b = weights![0] * a
var c = (b + bias![0])
c.elements.map(nn.fncSigLog)

//print(c)

 var d = weights![1] * c
 var e = (d + bias![1])
 e.elements.map(nn.fncSigLog)

 print(e)

*/







