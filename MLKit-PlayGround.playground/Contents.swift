//: Playground - noun: a place where people can play

import UIKit
import MLKit
import Upsurge


// Initialize Data Set
var dataset:[[Float]] = [[1.0,2.0],[2.0, 2.0], [1.0, 3.0], [1.0, 2.5],[1.0, 4.5]]

// Instantiate kMeans Object
var model = KMeans(dataset: dataset, k: 1)


model.train()

print(model.obtainCentroids())