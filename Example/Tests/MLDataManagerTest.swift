//
//  MLDataManagerTest.swift
//  MLKit
//
//  Created by Guled on 7/22/16.
//  Copyright © 2016 Somnibyte. All rights reserved.
//

//
//  MLDataManagerTest.swift
//  MLKit
//
//  Created by Guled on 7/22/16.
//  Copyright © 2016 Somnibyte. All rights reserved.
//

import XCTest
@testable import MLKit
@testable import Upsurge

class MLDataManagerTests: XCTestCase {

    let data: [Float] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let nonFloat: [String] = ["1", "2", "3"]
    let output: [Float] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5]


    func testMean() {
        let mean = MLDataManager.mean(data)
        let actualMean = Float(5.5)
        XCTAssertEqual(mean, actualMean)
    }

    func testDataToMatrix() {
        let feature: [Float] = [1.0, 1.0]
        let output: [Float] = [1.0, 1.0]
        let convertedData = MLDataManager.dataToMatrix([feature], output: output)

        let matrix = convertedData.0
        let outputArr = convertedData.1

        let actualMatrix = Matrix<Float>(rows: 2, columns: 2, elements: [1.0, 1.0, 1.0, 1.0])
        let actualOutput: ValueArray<Float> = [1.0, 1.0]

        XCTAssertEqual(matrix.elements, actualMatrix.elements)
        XCTAssertEqual(outputArr, actualOutput)
    }

    func testconvertDataOfTypeStringToFloat() {
        let floatData = try! MLDataManager.convertMyDataToFloat(nonFloat)
        let actualFloats: [Float] = [1.0, 2.0, 3.0]

        XCTAssertEqual(floatData, actualFloats)
    }

    func testSplitData() {
        let fakeData: [Float] = [1, 2, 3, 4, 5]
        // Cut the data in half
        let split = try! MLDataManager.splitData(fakeData, fraction: 0.5)

        let actualFirstHalf: [Float] = [1.0, 2.0]
        let actualSecondHalf: [Float] = [3.0, 4.0, 5.0]

        XCTAssertEqual(split.0, actualFirstHalf)
        XCTAssertEqual(split.1, actualSecondHalf)
    }

    func testConvertToPolynomialOfDegree() {
        let fakeData: [Float] = [1, 2, 3, 4, 5]
        let polynomialFeatures = try! MLDataManager.convertDataToPolynomialOfDegree(fakeData, degree: 2)
        print(polynomialFeatures)

        // First feature is 'fakeData' variable
        let secondFeature: [Float] = [1.0, 4.0, 9.0, 16.0, 25.0]

        XCTAssertEqual(polynomialFeatures[0], fakeData)
        XCTAssertEqual(polynomialFeatures[1], secondFeature)
    }

}
