//
//  PolynomialRegressionSpec.swift
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

class PolynomialRegressionSpec: QuickSpec {

    var weights: Matrix<Float>!
    let estimatedFinalWeights: ValueArray<Float> = [-99999.9, 303.321, 1.42297]
    var rss: Float!
    var quickPrediction: Float!
    let estimatedPrediction = Float(257921.0)

    override func spec() {

        beforeSuite {
            // Obtain data from csv file
            let path = Bundle(for: PolynomialRegressionSpec.self).path(forResource: "kc_house_data", ofType: "csv")
            let csvUrl = NSURL(fileURLWithPath: path!)
            let file = try! String(contentsOf: csvUrl as URL, encoding: String.Encoding.utf8)
            let data = CSVReader(with: file)

            // Setup the features we need and convert them to floats if necessary
            let training_data_string = data.columns["sqft_living"]!
            let training_data_2_string = data.columns["bedrooms"]!

            // Features
            let training_data = training_data_string.map { Float($0)! }
            let training_data_2 = training_data_2_string.map { Float($0)! }

            // Output
            let output_as_string = data.columns["price"]!
            let output_data = output_as_string.map { Float($0)! }

            // Fit the model
            let polynomialModel = PolynomialLinearRegression()

            // Setup initial weights
            let initial_weights = Matrix<Float>(rows: 3, columns: 1, elements: [-100000.0, 1.0, 1.0])

            // Fit the model and obtain the weights
            self.weights = try! polynomialModel.train([training_data, training_data_2], output: output_data, initialWeights: initial_weights, stepSize: Float(4e-12), tolerance: Float(1e9))

            // Compute RSS
            self.rss = try! polynomialModel.RSS([training_data, training_data_2], observation: output_data)

            // Make a prediction
            self.quickPrediction = polynomialModel.predict([Float(1.0), Float(1180.0), Float(1.0)], yourWeights: self.weights.elements)
        }

        it("Should produce weights equivalent to our estimated weights.") {

            expect(self.weights.elements[0]).to(beCloseTo(self.estimatedFinalWeights[0], within: 0.1))
            expect(self.weights.elements[1]).to(beCloseTo(self.estimatedFinalWeights[1], within: 0.1))
            expect(self.weights.elements[2]).to(beCloseTo(self.estimatedFinalWeights[2], within: 0.1))
        }

        it("Should be able to produce a prediction equivalent to our estimated prediction.") {

            expect(self.quickPrediction).toEventually(beCloseTo(self.estimatedPrediction, within: 1))
        }

    }

}
