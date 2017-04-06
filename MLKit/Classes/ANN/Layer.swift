//
//  Layer.swift
//  Pods
//
//  Created by Guled  on 4/6/17.
//
//

import Foundation
import Upsurge

class Layer {

    /// Ex: If layerSize is (2,3) then the layer has 2 neurons and each neuron has 3 outgoing synapses.
    var layerSize: (neurons: Int, outgoingSynapsesForEachNeuron: Int)?

    /// Matrix of bias values.
    public var bias: Matrix<Float>?

    /// Matrix of weight values.
    public var weights: Matrix<Float>?

    /// Matrix representing values that are passed as input to the neurons of the current layer.
    public var input: Matrix<Float>?

    /// Matrix representing the aggregate of the 
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

