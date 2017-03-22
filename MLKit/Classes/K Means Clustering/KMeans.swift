//
//  KMeans.swift
//  Pods
//
//  Created by Guled  on 2/20/17.
//
//

import Foundation
import Upsurge

open class KMeans {

    /// The centroids of your K-Means model
    fileprivate var centroids: Matrix<Float>!

    /// Represents the number of clusters
    fileprivate var k: Int!

    /// A boolean that indicates whether K-Means++ will be applied as the initialization method
    fileprivate var smartInit: Bool!

    /// The dataset of your model
    fileprivate var dataset: Matrix<Float>!

    fileprivate var associationArr: [Int]!

    fileprivate var dimension: Int!

    public init(dataset: [[Float]], k: Int) {

        // Set k (number of clusters)
        self.k = k

        // Initilization the centroids
        self.centroids = randomCentroidInit(inputDataset: dataset)

        // Convert our dataset into a Matrix
        self.dataset = Matrix(dataset)

        // The associations array will be used to indicate which data point belongs to which cluster
        self.associationArr = [Int](repeatElement(0, count: self.dataset.count))

    }

    /**
     The randomCentroidInit method returns clusters that have been chosen randomly from the dataset itself.
    */
    func randomCentroidInit(inputDataset: [[Float]]) -> Matrix<Float> {

        var randomClusters =  Array(repeatElement([Float](repeatElement(0.0, count: inputDataset[0].count)), count: k))

        for i in 0..<k {

            let randomIdx = Int(arc4random_uniform(UInt32(inputDataset.count)))
            randomClusters[i] = inputDataset[randomIdx]
        }

        return Matrix<Float>(randomClusters)
    }

    /**
     The train method performs KMeans with the provided dataset and choice of 'k' value. After calling the 'train' method please call the 'obtainCentroids' methods to retrieve the newly adjusted centroids.
     */
    open func train() {

        // Create k Clusters
        var trainingCentroids: Matrix<Float> = centroids

        var comparison: Matrix<Float>!

        var distances: [Float] = Array(repeatElement(0.0, count: k))

        while true {

            // Obtain the previous clusters
            comparison = trainingCentroids

            for var i in 0..<dataset.count {

                var smallestDistance = Float.infinity
                var idx = 0
                for var i in (0...k-1) {

                    // Calculate the distance between a centroid and a given point
                    var difference = dataset.row(idx) - trainingCentroids.row(i)
                    var squared = difference * difference
                    var reduced = squared.reduce(0, +)

                    distances[i] = sqrtf(reduced)

                    if distances[i] < smallestDistance {
                        smallestDistance = distances[i]
                        idx = i
                    }
                }

                self.associationArr[i] = idx
            }

            // Reset the clusters
            trainingCentroids = Matrix(rows: k, columns: dataset.columns, repeatedValue: 0.0)

            // Move the centroids

            for var i in associationArr {
                var currentCentroid = trainingCentroids.row(associationArr[i])
                currentCentroid += dataset.row(i)
            }

            for var i in (0...k-1) {
                var currentCentroid = trainingCentroids.row(i)
                currentCentroid.map({ $0/Float(dataset.count) })
            }

            var finalDifference = Float(0)

            for var i in (0...k-1) {

                var difference = comparison.row(i) - trainingCentroids.row(i)

                difference.map({$0 * $0})

                var aggregate = difference.reduce(0, +)

                var distance = sqrtf(aggregate)

                finalDifference = (finalDifference > distance) ? finalDifference:distance

            }

            if finalDifference < 1 {
                break
            }

        }

        self.centroids = trainingCentroids
    }

    /**
     obtainCentroids

     - returns: Your newly adusted centroids in the form of a Matrix (See UpSurge Framework)
     */
    open func obtainCentroids() -> Matrix<Float> {
        return self.centroids
    }

}
