//
//  RidgeRegressionSpec.swift
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

class RidgeRegressionSpec: QuickSpec {

    let estimatedWeights: ValueArray<Float> = [-0.201522, 263.089]
    let estimatedPrediction: Float = 310445.062
    var weights: Matrix<Float>!
    var quickPrediction: Float!

    override func spec() {

        beforeSuite {

            // Obtain data from csv file
            let path = Bundle(for: RidgeRegressionSpec.self).path(forResource: "kc_house_data", ofType: "csv")
            let csvUrl = NSURL(fileURLWithPath: path!)
            let file = try! String(contentsOf: csvUrl as URL, encoding: String.Encoding.utf8)
            let data = CSVReader(with: file)

            // Setup the features we need and convert them to floats if necessary
            let training_data_string = data.columns["sqft_living"]!
            // Features
            let training_data = training_data_string.map { Float($0)! }

            // Output
            let output_as_string = data.columns["price"]!
            let output_data = output_as_string.map { Float($0)! }

            // Fit the model
            let ridgeModel = RidgeRegression()

            // Setup initial weights
            let initial_weights = Matrix<Float>(rows: 2, columns: 1, elements: [0.0, 0.0])

            // Fit the model and obtain the weights
            self.weights = try! ridgeModel.train([training_data], output: output_data, initialWeights: initial_weights, stepSize: Float(1e-12), l2Penalty: 0.0, maxIterations: 1000)

            // Make a prediction
            self.quickPrediction = ridgeModel.predict([Float(1.0), Float(1.18000000e+03)], yourWeights: self.weights.elements)

        }

        it("Should produce adequate weights.") {

            expect(self.weights.elements[0]).to(beCloseTo(self.estimatedWeights[0], within: 0.1))
            expect(self.weights.elements[1]).to(beCloseTo(self.estimatedWeights[1], within: 0.1))
        }

        it("Should be able to produce a prediction equivalent to our estimated prediction. ") {

            expect(self.quickPrediction).to(equal(self.estimatedPrediction))
        }

    }

}
