//: Playground - noun: a place where people can play

import UIKit
import Upsurge


extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}


struct InputDataType {

    var data: [(input: [Float], target:[Float])]

    var lengthOfTrainingData: Int {
        get {
            return data.count
        }
    }
}


class Layer {


    var layerSize: (rows: Int, columns: Int)?

    public var bias: Matrix<Float>?

    public var weights: Matrix<Float>?

    public var input: Matrix<Float>?

    public var zValues: Matrix<Float>?

    public var activationValues: Matrix<Float>?

    public var Δw: Matrix<Float>?

    public var Δb: Matrix<Float>?

    public var activationFnc: Bool = false


    init(size: (rows: Int, columns: Int)){

        self.layerSize = size

        self.bias = generateRandomBiases()

        self.weights = generateRandomWeights()

        self.Δb = Matrix<Float>([Array<Float>(repeating: 0.0, count: (self.bias?.elements.count)!)])

        self.Δw = Matrix<Float>([Array<Float>(repeating: 0.0, count: (self.weights?.elements.count)!)])
    }

    public func fncStep(val: Float) -> Float {
        return val >= 0 ? 1.0 : 0.0
    }


    func forward(activation:Matrix<Float>) -> Matrix<Float> {

        var a = activation

        self.input = activation

        a = (self.weights! * a)

        a = Matrix<Float>(rows: a.rows, columns: a.columns, elements: a.elements + self.bias!.elements)

        self.zValues = a

        if activationFnc == true {
            a = Matrix<Float>(rows: a.rows, columns: a.columns, elements: a.elements.map(fncStep))
        }else{
            a = Matrix<Float>(rows: a.rows, columns: a.columns, elements: a.elements.map(fncSigLog))
        }


        self.activationValues = a


        return a
    }


    func produceOuputError(cost: Matrix<Float>) -> Matrix<Float> {

        var z = self.zValues

        z = Matrix<Float>(rows: (z?.rows)!, columns: (z?.columns)!, elements:ValueArray<Float>(z!.elements.map(derivativeOfSigLog)))

        var sigmaPrime = z

        var Δ = cost * sigmaPrime!

        return Δ
    }


    func propagateError(previousLayerDelta: Matrix<Float>, nextLayer: Layer) -> Matrix <Float> {

        // Compute the current layers δ value.
        var nextLayerWeightTranspose = transpose(nextLayer.weights!)

        var deltaMultipliedBywT =  nextLayerWeightTranspose * previousLayerDelta

        var sigmaPrime = Matrix<Float>(rows: (self.zValues?.rows)!, columns: (self.zValues?.columns)!, elements: ValueArray(self.zValues!.elements.map(derivativeOfSigLog)))

        var currentLayerDelta =  Matrix<Float>(rows: deltaMultipliedBywT.rows, columns: deltaMultipliedBywT.columns, elements:  ValueArray(deltaMultipliedBywT.elements * sigmaPrime.elements))

        // Update the current layers weights
        var inputTranspose = transpose(self.input!)

        var updatedWeights = currentLayerDelta * inputTranspose

        self.Δw = updatedWeights

        // Update the current layers bias
        self.Δb = currentLayerDelta

        return currentLayerDelta
    }


    func updateWeights(miniBatchSize: Int, eta: Float){

        var learningRate = eta/Float(miniBatchSize)

        var changeInWeights = learningRate * self.Δw!

        var changedBiases = learningRate * self.Δb!

        self.weights = self.weights! - changeInWeights

        self.bias = self.bias! - changedBiases
    }

    // TODO: Make private method
    func generateRandomBiases() -> Matrix<Float> {
        
        var biasValues: [Float] = []

        for i in 0..<layerSize!.columns {
            var biasValue = generateRandomNumber()
            biasValues.append(biasValue)
        }

        return Matrix<Float>(rows: (layerSize?.columns)!, columns: 1, elements: ValueArray<Float>(biasValues))
    }

    func generateRandomWeights() -> Matrix<Float>{
        var weightValues: [Float] = []

        for i in 0..<(layerSize!.rows * layerSize!.columns) {
            var weightValue = generateRandomNumber()

            weightValues.append(weightValue)
        }


        return Matrix<Float>(rows: layerSize!.columns, columns: layerSize!.rows, elements: ValueArray<Float>(weightValues))
    }

    /**
     The generateRandomNumber generates a random number (normal distribution using Box-Muller tranform).

     - returns: A random number (normal distribution).
     */
    func generateRandomNumber() -> Float{
        let u = Float(arc4random()) / Float(UINT32_MAX)
        let v = Float(arc4random()) / Float(UINT32_MAX)
        let randomNum = sqrt( -2 * log(u) ) * cos( Float(2) * Float(M_PI) * v )

        return randomNum
    }

    public func fncSigLog(val: Float) -> Float {
        return 1.0 / (1.0 + exp(-val))
    }

    public func derivativeOfSigLog(val: Float) -> Float {
        return fncSigLog(val: val) * (1.0 - fncSigLog(val: val))
    }

}








// Feed Forward Implementation 
class NeuralNetwork {

    public var layers: [Layer] = []
    public var numberOfLayers: Int?
    public var networkSize: (inputLayerSize:Int, outputLayerSize:Int)?

    init(size:(Int, Int)){

        self.networkSize = size

    }

    func addLayer(layer: Layer){

        self.layers.append(layer)
    }

    public func feedforward(input:Matrix<Float>) -> Matrix<Float> {

        var a = input

        for l in layers {
            a = l.forward(activation: a)
        }

        return a
    }


    public func SGD(trainingData: InputDataType, epochs: Int, miniBatchSize: Int, eta: Float, testData: InputDataType? = nil){

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

    public func updateMiniBatch(miniBatch: InputDataType, eta: Float){


        for batch in miniBatch.data {
            var inputMatrix = Matrix<Float>(rows: batch.input.count, columns: 1, elements: batch.input)
            var outputMatrix = Matrix<Float>(rows: batch.target.count, columns: 1, elements: batch.target)

            self.backpropagate(input: inputMatrix, target: outputMatrix)
        }

        for layer in layers {

            layer.updateWeights(miniBatchSize: miniBatch.lengthOfTrainingData, eta: eta)

        }

    }

    public func backpropagate(input: Matrix<Float>, target: Matrix<Float>){

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


/*
var nn = NeuralNetwork(size: [2,3,1])
var a = Matrix<Float>(rows: 2, columns: 1, elements: [2.0,10.0])
var trainingData = InputDataType( data: [ ([0.0,0.0], [0.0]), ([1.0,1.0],[1.0]) ] )
print(nn.weights?[0])
print("\n")
print(Layer(size: (2,3)).generateRandomWeights())
*/



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

/*
var nn = NeuralNetwork(size: (2,1))
nn.addLayer(layer: Layer(size: (2,3)))
nn.addLayer(layer: Layer(size: (3,1)))
var trainingData = InputDataType(data: [ ([0.0, 0.0], [0.0]), ([1.0, 1.0], [1.0]), ([1.0, 0.0], [0.0]), ([0.0, 1.0], [0.0])])
var input1 = Matrix<Float>(rows: 2, columns: 1, elements: [0.0,0.0])
var input2 = Matrix<Float>(rows: 2, columns: 1, elements: [0.0,1.0])
var input3 = Matrix<Float>(rows: 2, columns: 1, elements: [1.0,0.0])
var input4 = Matrix<Float>(rows: 2, columns: 1, elements: [1.0,1.0])
nn.layers[0].activationFnc = false
nn.layers[1].activationFnc = true
nn.SGD(trainingData: trainingData, epochs: 200, miniBatchSize: 3, eta: 0.5)
print(nn.feedforward(input: input1))
print(nn.feedforward(input: input2))
print(nn.feedforward(input: input3))
print(nn.feedforward(input: input4))
*/


