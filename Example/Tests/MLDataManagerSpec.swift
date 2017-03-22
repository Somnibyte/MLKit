//
//  MLDataManagerSpec.swift
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

class MLDataManagerSpec: QuickSpec {

    let data: [Float] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let nonFloat: [String] = ["1", "2", "3"]
    let output: [Float] = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5]

    override func spec() {

        it("Should be able to compute mean.") {

            let mean = MLDataManager.mean(self.data)
            let actualMean = Float(5.5)
            expect(mean).to(equal(actualMean))
        }

        it("Should be able to convert training data to matrix form.") {

            let feature: [Float] = [1.0, 1.0]
            let output: [Float] = [1.0, 1.0]
            let convertedData = MLDataManager.dataToMatrix([feature], output: output)

            let matrix = convertedData.0
            let outputArr = convertedData.1

            let actualMatrix = Matrix<Float>(rows: 2, columns: 2, elements: [1.0, 1.0, 1.0, 1.0])
            let actualOutput: ValueArray<Float> = [1.0, 1.0]

            expect(matrix.elements).to(equal(actualMatrix.elements))
            expect(outputArr).to(equal(actualOutput))
        }

        it("Should be able to convert String data to Float data.") {

            let floatData = try! MLDataManager.convertMyDataToFloat(self.nonFloat)
            let actualFloats: [Float] = [1.0, 2.0, 3.0]

            expect(floatData).to(equal(actualFloats))
        }

        it("Should be able to split data successfully.") {

            let fakeData: [Float] = [1, 2, 3, 4, 5]
            // Cut the data in half
            let split = try! MLDataManager.splitData(fakeData, fraction: 0.5)

            let actualFirstHalf: [Float] = [1.0, 2.0]
            let actualSecondHalf: [Float] = [3.0, 4.0, 5.0]

            expect(split.0).to(equal(actualFirstHalf))
            expect(split.1).to(equal(actualSecondHalf))
        }

        it("Should be able to convert data to polynomial of degree x.") {

            let fakeData: [Float] = [1, 2, 3, 4, 5]
            let polynomialFeatures = try! MLDataManager.convertDataToPolynomialOfDegree(fakeData, degree: 2)

            // First feature is 'fakeData' variable
            let secondFeature: [Float] = [1.0, 4.0, 9.0, 16.0, 25.0]

            expect(polynomialFeatures[0]).to(equal(fakeData))
            expect(polynomialFeatures[1]).to(equal(secondFeature))
        }

    }
}
