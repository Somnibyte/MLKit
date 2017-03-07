//
//  Genome.swift
//  Pods
//
//  Created by Guled  on 3/7/17.
//
//

import Foundation


/// Interface for a genome. Use this protocol to define your own kind of genome. 
public protocol GenomeProtocol {

    /// Fitness of a particular genome.
    var fitness: Float? { get set }

    /// Genotype representation of the genome.
    var genotypeRepresentation: [Float] { get set }
}

extension GenomeProtocol {

    /// Method used to update the fitness of a genome based on conditions specified by the programmer.
    func generateFitness() {

    }
}


/// Struct representation of a Genome. This implementation of a Genome does not come with the `generateFitness` method implemented for you since there are several ways to assess generating fitness for a genome. You are advised to create your own `generateFitness` method as an extension of the struct `Genome`. 
public struct Genome: GenomeProtocol {

    public init(genotype: [Float]){

        self.genotypeRepresentation = genotype
    }

    /// Genotype representation of the genome.
    public var genotypeRepresentation: [Float]

    /// Fitness of a particular genome.
    public var fitness: Float?

}
