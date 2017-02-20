//
//  SimpleLinearRegressionTest.swift
//  MLKit
//
//  Created by Guled on 7/22/16.
//  Copyright © 2016 Somnibyte. All rights reserved.
//

import XCTest
@testable import MLKit

class SimpleLinearRegressionTests: XCTestCase {

    let dataset: Array<Float> = [0, 1, 2, 3, 4]
    let output: Array<Float> = [1, 3, 7, 13, 21]

    // Tests fitting a model without using Gradient Descent (closed form solution)
    func testFitNonGradientDescent() {

        let model = SimpleLinearRegression()

        let weights = model.train(dataset, output: output)

        let actual = (Float(5.0), Float(-1.0))

        XCTAssertEqual(weights.0, actual.0)
        XCTAssertEqual(weights.1, actual.1)
    }

    // Tests fitting a model using Gradient Descent
    func testFitGradientDescent() {
        let model = SimpleLinearRegression()

        let weights = try! model.train(dataset, output: output, stepSize: 0.05, tolerance: 0.01)

        let actual = (Float(4.99797), Float(-0.994207))

        XCTAssertEqualWithAccuracy(weights.0, actual.0, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(weights.1, actual.1, accuracy: 0.0001)
    }

    // Tests RSS of a model
    func testRSS() {
        let model = SimpleLinearRegression()

        // First we fit our model
        let weights = try! model.train(dataset, output: output, stepSize: 0.05, tolerance: 0.01)

        // Then we can use the cost function
        let rss = model.RSS(dataset, output: output, slope: weights.0, intercept: weights.1)

        let actualRSS = Float(14.0001)

        XCTAssertEqualWithAccuracy(rss, actualRSS, accuracy: 0.0001)

    }

    // Test Quick Prediction (passing in one input point and getting a prediction afterwards)
    func testOneTimePrediction() {

        let model = SimpleLinearRegression()

        // First we fit our model
        let weights = try! model.train(dataset, output: output, stepSize: 0.05, tolerance: 0.01)

        // Make one-time prediction
        let quickPrediction = model.predict(weights.0, intercept: weights.1, inputValue: 2)

        let actualPrediction = Float(9.00173)

        XCTAssertEqualWithAccuracy(quickPrediction, actualPrediction, accuracy: 0.0001)
    }

}
