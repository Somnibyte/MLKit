//
//  KMeans.swift
//  Pods
//
//  Created by Guled  on 2/20/17.
//
//

import Foundation


open class KMeans {

    fileprivate var centroids:[Float]!
    fileprivate var k:Int!
    fileprivate var smartInit:Bool!
    fileprivate var dataset:[Float]!
    fileprivate var associationArr:[Int]!
    
    public init(dataset:[Float], smartInit:Bool, k:Int){
        
        // KMeans++ initialization method will be activated if smartInit is true
        self.smartInit = smartInit
        self.k = k
        self.dataset = dataset
        
        // The associations array will be used to indicate which data point belongs to which cluster
        self.associationArr = [Int](repeatElement(0, count: self.dataset.count))

    }
    
    
    /*
    Credit goes to Martin. First Answer:
     http://stackoverflow.com/questions/30309556/generate-random-numbers-with-a-given-distribution
    */
    func randomNumber(probabilities: [Float]) -> Int {
        
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = sum * Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = Float(0.0)
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }

    
    func calcSquaredDistOfFirstCenter(input_centroids:[Float]) -> [Float]{
        var squaredDists = [Float](repeating: 0.0, count: self.dataset.count)
        
        for (var idx, var x) in squaredDists.enumerated(){
            let aggregate = pow(dataset[idx] - input_centroids[0] , 2.0)

            squaredDists[idx] = pow(sqrt(aggregate),2.0)/Float(self.dataset.count)
        }
        
        return squaredDists
    }
    
    
    func calcMinSquaredDist(range:Int, input_centroids:[Float]) -> [Float] {
        
        var squaredDists = [Float](repeating: 0.0, count: self.dataset.count)
        var distances:[Float] = []
        
        for (var idx, var x) in squaredDists.enumerated() {
            
            for var i in (0..<range) {
                let aggregate = pow(dataset[idx] - input_centroids[i] , 2.0)
                
                distances.append(pow(sqrt(aggregate), 2.0))
            }
            
            squaredDists[idx] = (distances.min()!)/Float(self.dataset.count)
            distances = []
        }
        
        
        return squaredDists
    }
    
    
    /**
     The smartInitialization method initializes our centroids using the KMeans++ algorithm.
     
     - returns: Centroids that are intiliazed via KMeans++ method.
     */
    func smartInitialization() -> [Float] {
        
        // Initialize centroids
        var smart_centroids:[Float] = [Float](repeating: 0.0, count: k)
        
        // Choose an initial center uniformly at random from our dataset.
        // Compute the vector containing the square distances between all points in the dataset and center 1 (centroids[0]).
        let randomIndex = Int(arc4random_uniform(UInt32(self.dataset.count)))
        
        centroids[0] = self.dataset[randomIndex]
        
        // Compute the distances from the first centroid chosen to all of the other data points 
        var squaredDist:[Float] = calcSquaredDistOfFirstCenter(input_centroids: smart_centroids)
        
        
        // Initialize the rest of the centroids 
        for var i in (1..<self.k) {
            
            // Pick next data point at random 
            var idx = randomNumber(probabilities: squaredDist)
            
            centroids[i] = self.dataset[idx]
            
            
            squaredDist = calcMinSquaredDist(range: i+1, input_centroids: smart_centroids)
        }
        
        
        return smart_centroids
    }
    
    
    
    /**
     The train method performs KMeans with the provided dataset and choice of 'k' value. After calling the 'train' method please call the 'obtainCentroids' methods to retrieve the newly adjusted centroids.
     */
    open func train(){
        
        // Create k Clusters
        var training_centroids:[Float] = [Float](repeating: 0.0, count: k)
        
        if self.smartInit == true {
            training_centroids = smartInitialization()
        }
        
        
        var comparison:[Float] = []
        var distances:[Float] = Array(repeatElement(0.0, count: k))
        
        
        while true {
            
            // Obtain the previous clusters
            comparison = training_centroids
            
            for (var i, var x) in dataset.enumerated() {
                
                var smallestDistance = Float.infinity
                var idx = 0
                for var i in (0...k-1){
                    
                    // Calculate the distance between a centroid and a given point
                    let aggregate = pow(dataset[idx] - training_centroids[i] , 2.0)

                    
                    distances[i] = sqrtf(aggregate)
                    
                    if distances[i] < smallestDistance {
                        smallestDistance = distances[i]
                        idx = i
                    }
                }
                
                self.associationArr[i] = idx
            }
            
            // Reset the clusters
            training_centroids = [Float](repeating: 0.0, count: k)
            
            // Move the centroids
            for (var i, var x) in dataset.enumerated() {
                training_centroids[self.associationArr[i]] += x
            }
            
            for var i in (0...k-1){
                training_centroids[i] /= Float(dataset.count)
            }
            
            
            var difference = Float(0);
            
            for var i in (0...k-1){
                
                let aggregate = powf(comparison[i] - centroids[i] , 2.0)
                
                var distance = sqrtf(aggregate)
                
                difference = (difference > distance) ? difference:distance
                
                
            }
            
            if difference < 1 {
                break
            }
            
        }
        
        
        
        self.centroids = training_centroids
    }

    
    
    
    /**
     obtainCentroids
    
     - returns: Your newly adusted centroids.
     */
    open func obtainCentroids() -> [Float] {
        return self.centroids
    }

    
}
