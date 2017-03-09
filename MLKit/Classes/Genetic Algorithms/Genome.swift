//
//  Genome.swift
//  Pods
//
//  Created by Guled  on 3/7/17.
//
//

import Foundation


/// Blueprint for a Genome. It is encouraged to inherit from this base class in order to accomodate for your needs.
open class Genome {

    /// Genotype representation of the genome.
    public var genotypeRepresentation: [Float]

    /// Fitness of a particular genome.
    public var fitness: Float = 0

    public init(genotype: [Float]) {

        self.genotypeRepresentation = genotype
    }

    // Method used to assign a fitness value for a Genome
    /*  This method is not given in the framework as there is no way to tell how you will evaluate fitness within your own project. Please implement your own 'generateFitness' method. An example is given in the Example Flappy Bird Game Project.
    open func generateFitness() {

    }
    */
}
