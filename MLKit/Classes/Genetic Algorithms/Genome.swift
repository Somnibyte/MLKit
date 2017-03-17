//
//  Genome.swift
//  Pods
//
//  Created by Guled  on 3/7/17.
//
//

import Foundation

/// Protocol for a Genome. It is encouraged that you create your own `generateFitness` method as there are several ways to assess fitness. You are required, on the other hand, to have a genotype representation and a fitness for every Genome.
public protocol Genome {

    /// Genotype representation of the genome.
    var genotypeRepresentation: [Float] { get set }

    /// Fitness of a particular genome.
    var fitness: Float { get set }

}
