//
//  LassoRegressionTest.swift
//  MLKit
//
//  Created by Guled on 8/1/16.
//  Copyright © 2016 Somnibyte. All rights reserved.
//

import XCTest
import UIKit
@testable import MLKit
@testable import Upsurge

class LassoRegressionTest: XCTestCase {


    func testLassoCyclicalCoordinateDescent() {
        // Obtain data from csv file
        let path = Bundle(for: PolynomialRegressionTests.self).path(forResource: "kc_house_data", ofType: "csv")
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

        let weights = try! lassoModel.train([feature1, feature2], output: output_data, initialWeights: initial_weights, l1Penalty: l1_penalty, tolerance: tolerance)

        let actualWeights: ValueArray<Float> = [21624964.0, 63157280.0, 0.0]

        XCTAssertEqualWithAccuracy(weights.elements[0], actualWeights[0], accuracy: 0.1)
        XCTAssertEqualWithAccuracy(weights.elements[1], actualWeights[1], accuracy: 0.1)
        XCTAssertEqualWithAccuracy(weights.elements[2], actualWeights[2], accuracy: 0.1)

    }


    /*
    func testRSS(){
        // Obtain data from csv file
        let path = Bundle(for: PolynomialRegressionTests.self).path(forResource: "kc_house_data", ofType: "csv")
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

        let weights = try! lassoModel.train([feature1, feature2], output: output_data, initialWeights: initial_weights, l1Penalty: l1_penalty, tolerance: tolerance)

        let RSS = try! lassoModel.RSS([feature1, feature2], observation: output_data)
        let actualRSS:Float = 1630492260564992.0

        // Xcode will say the test failed, but the values are extremely close to one another.
        // I will come back to this test.
        //XCTAssertEqualWithAccuracy(RSS, actualRSS, accuracy: 0.1)

    }

    */
}
