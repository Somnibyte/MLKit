//
//  LayerProtocol.swift .swift
//  Pods
//
//  Created by Guled  on 2/23/17.
//
//

import Foundation
import Upsurge


public protocol Layer {

    var listOfNeurons: [Neuron] { get set }

    var numberOfNueronsInLayer: Int { get set }

}


public protocol InputandOutputLayerMethods {

    func printLayer(layer:Layer)
}
