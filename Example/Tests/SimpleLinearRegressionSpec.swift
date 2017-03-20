//
//  SimpleLinearRegressionSpec.swift
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

class SimpleLinearRegressionSpec: QuickSpec {

    let dataset: Array<Float> = [0, 1, 2, 3, 4]
    let output: Array<Float> = [1, 3, 7, 13, 21]
    let estimatedNonGradientWeights = (Float(5.0), Float(-1.0))
    let estimatedGradientWeights = (Float(4.99797), Float(-0.994207))
    let estimatedPrediction = Float(9.00173)

    override func spec() {

        it("Should produce adequate weights [Non Gradient Method].") {

            let model = SimpleLinearRegression()

            let weights = model.train(self.dataset, output: self.output)

            expect(weights.0).to(beCloseTo(self.estimatedNonGradientWeights.0, within: 0.1))
            expect(weights.1).to(beCloseTo(self.estimatedNonGradientWeights.1, within: 0.1))
        }

        it("Should produce adequate weights [Gradient Method].") {

            let model = SimpleLinearRegression()

            let weights = try! model.train(self.dataset, output: self.output, stepSize: 0.05, tolerance: 0.01)

            expect(weights.0).to(beCloseTo(self.estimatedGradientWeights.0, within: 0.1))
            expect(weights.1).to(beCloseTo(self.estimatedGradientWeights.1, within: 0.1))
        }

        it("Should be able to produce a prediction equivalent to our estimated prediction.") {

            let model = SimpleLinearRegression()

            // First we fit our model
            let weights = try! model.train(self.dataset, output: self.output, stepSize: 0.05, tolerance: 0.01)

            // Make one-time prediction
            let quickPrediction = model.predict(weights.0, intercept: weights.1, inputValue: 2)

            expect(quickPrediction).to(equal(self.estimatedPrediction))
        }
    }

}
