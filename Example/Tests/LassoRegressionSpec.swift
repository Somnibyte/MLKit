//
//  LassoRegressionSpec.swift
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

class LassorRegressionSpec: QuickSpec {

    var weights: Matrix<Float>!
    let estimatedFinalWeights: ValueArray<Float> = [21624964.0, 63157280.0, 0.0]

    override func spec() {

        beforeSuite {
            // Obtain data from csv file
            let path = Bundle(for: LassorRegressionSpec.self).path(forResource: "kc_house_data", ofType: "csv")
            let csvUrl = NSURL(fileURLWithPath: path!)
            let file = try! String(contentsOf: csvUrl as URL, encoding: String.Encoding.utf8)
            let data = CSVReader(with: file)

            // Setup the features we need and convert them to floats if necessary
            let training_data_string = data.columns["sqft_living"]!
            let training_data_2_string = data.columns["bedrooms"]!

            // Features
            let feature1 = training_data_string.map { Float($0)!}
            let feature2 = training_data_2_string.map {Float($0)!}

            // Output
            let output_as_string = data.columns["price"]!
            let output_data = output_as_string.map { Float($0)! }

            // Setup Model
            let lassoModel = LassoRegression()

            // Set Initial Weights
            let initial_weights = Matrix<Float>(rows: 3, columns: 1, elements: [0.0, 0.0, 0.0])

            // Params
            let l1_penalty = Float(1e7)
            let tolerance = Float(3.0)

            self.weights = try! lassoModel.train([feature1, feature2], output: output_data, initialWeights: initial_weights, l1Penalty: l1_penalty, tolerance: tolerance)

        }

        it("Should produce adequate weights.") {

            expect(self.weights.elements[0]).to(beCloseTo(self.estimatedFinalWeights[0], within: 0.1))
            expect(self.weights.elements[1]).to(beCloseTo(self.estimatedFinalWeights[1], within: 0.1))
            expect(self.weights.elements[2]).to(beCloseTo(self.estimatedFinalWeights[2], within: 0.1))
        }

    }

}
