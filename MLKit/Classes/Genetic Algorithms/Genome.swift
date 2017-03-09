//
//  Genome.swift
//  Pods
//
//  Created by Guled  on 3/7/17.
//
//

import Foundation

/// Blueprint for a Genome. It is encouraged to inherit from this base class in order to accomodate for your needs.
public protocol Genome {

    /// Genotype representation of the genome.
    var genotypeRepresentation: [Float] { get set }

    /// Fitness of a particular genome.
    var fitness: Float { get set }

}

