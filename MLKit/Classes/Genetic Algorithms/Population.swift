//
//  Population.swift
//  Pods
//
//  Created by Guled  on 3/7/17.
//
//

import Foundation

/// Handles processes involving selection.
open class PopulationManager<G: GenomeProtocol>{


    /**
     The selectParents method selects two parents from the population to create an offspring.

     - parameter genomes: An array of genomes. 

     - returns: A tuple consisted two genomes.
     */
    open static func selectParents(genomes:[G]) -> (G,G){

        var genomes = genomes

        var tournament:[G] = []

        // Create a "tournament" (an array of randomly selected genomes).
        for _ in 0..<genomes.count {
            tournament.append(genomes[Int(arc4random_uniform(UInt32(genomes.count-1)))])
        }

        var firstBestGenome:G?
        var secondBestGenome:G?

        var maxFitness:Float = -10000
        var indexOfBestGenome:Int = 0

        // Find the first genome that has the best fitness thus far.
        // Save and remove that individual from the list of genomes
        for (var i, var genome) in genomes.enumerated() {
            if genome.fitness! > maxFitness {
                maxFitness = genome.fitness!
                firstBestGenome = genome
                indexOfBestGenome = i
            }
        }

        genomes.remove(at: indexOfBestGenome)


        // Now look for the second best genome in the population

        maxFitness = -10000
        indexOfBestGenome = 0


        for (var i, var genome) in genomes.enumerated() {
            if genome.fitness! > maxFitness {
                maxFitness = genome.fitness!
                secondBestGenome = genome
                indexOfBestGenome = i
            }
        }

        genomes.remove(at: indexOfBestGenome)


        return (firstBestGenome!, secondBestGenome!)
    }
    
}
