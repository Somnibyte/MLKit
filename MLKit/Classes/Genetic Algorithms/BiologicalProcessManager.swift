//
//  BiologicalProcessManager.swift
//  Pods
//
//  Created by Guled  on 3/7/17.
//
//

import Foundation

/// Handles process involving crossover and mutation.
open class BiologicalProcessManager {

    // MARK: - Crossover Methods

    /**
     The onePointCrossover method performs the "one point" crossover operation.

     - parameter crossoverRate: Your crossover rate (should be between 0 and 1).
     - parameter parentOne: Parent represented as a Genome Object.
     - parameter parentTwo: Parent represented as a Genome Object.

     - returns: Two genotype representations. Depending on the crossover rate, you either get the parents genomes back or the new child genomes.
     */
    open static func onePointCrossover(crossoverRate: Float, parentOneGenotype: [Float], parentTwoGenotype: [Float]) -> ([Float], [Float]) {

        var randomProbability: Float = Float(arc4random()) / Float(UINT32_MAX)

        if randomProbability < crossoverRate {

            var pivot: Int = Int(arc4random_uniform(UInt32(parentOneGenotype.count)))

            var newGenotypeForChild1 = parentOneGenotype[0..<pivot] + parentTwoGenotype[pivot...parentTwoGenotype.count-1]

            var newGenotypeForChild2 = parentTwoGenotype[0..<pivot] + parentOneGenotype[pivot...parentTwoGenotype.count-1]

            var child1Genotype = Array<Float>(newGenotypeForChild1)

            var child2Genotype = Array<Float>(newGenotypeForChild2)

            return (child1Genotype, child2Genotype)

        } else {

            return (parentOneGenotype, parentTwoGenotype)
        }
    }

    // MARK: - Mutation Methods

    /**
     The generateRandomIndexes generates random indexes.

     - parameter genotypeCount: The `count` of the `genotypeRepresentation` of a Genome object.

     - returns: A tuple consisted of type Integer.

     */
    private static func generateRandomIndexes(genotypeCount: Int) -> (Int, Int) {
        var randomIndexOne = Int(arc4random_uniform(UInt32(genotypeCount)))
        var randomIndexTwo = Int(arc4random_uniform(UInt32(genotypeCount)))

        if randomIndexOne == randomIndexTwo {

            while true {

                randomIndexTwo = Int(arc4random_uniform(UInt32(genotypeCount)))

                if randomIndexTwo != randomIndexOne {
                    break
                } else {
                    continue
                }
            }
        }

        return (randomIndexOne, randomIndexTwo)
    }

    /**
     The bitFlipMutation method flips the bits of a genotype (genotype must only contain the numbers 0 and 1).
     The genotype representation is altered directly, nothing will be returned.

     - parameter mutationRate: Your mutation rate (should be between 0 and 1).
     - parameter genotype: The genotypeRepresentation array of a Genome object.

    */
    open static func bitFlipMutation(mutationRate: Float, genotype:inout [Float]) {

        var randomProbability: Float = Float(arc4random()) / Float(UINT32_MAX)

        if randomProbability < mutationRate {

            for (i, gene) in genotype.enumerated() {
                if gene == 0 {
                    genotype[i] = 1
                } else {
                    genotype[i] = 0
                }
            }
        }
    }

    /**
     The swapMutation method swaps genes of a Genome objects `genotypeRepresentation`.
     The genotype representation is altered directly, nothing will be returned.

     - parameter mutationRate: Your mutation rate (should be between 0 and 1).
     - parameter genotype: The genotypeRepresentation array of a Genome object.

     */
    open static func swapMutation(mutationRate: Float, genotype:inout [Float]) {

        var randomProbability: Float = Float(arc4random()) / Float(UINT32_MAX)

        if randomProbability < mutationRate {

            var randomIdx = generateRandomIndexes(genotypeCount: genotype.count - 1)

            var temp = genotype[randomIdx.0]

            genotype[randomIdx.0] = genotype[randomIdx.1]

            genotype[randomIdx.1] = temp
        }
    }

    /**
     The insertMutation method inserts random genes of a Genome objects `genotypeRepresentation` into random positions.
     The genotype representation is altered directly, nothing will be returned.

     - parameter mutationRate: Your mutation rate (should be between 0 and 1).
     - parameter genotype: The genotypeRepresentation array of a Genome object.

     */
    open static func insertMutation(mutationRate: Float, genotype:inout [Float]) {

        var randomProbability: Float = Float(arc4random()) / Float(UINT32_MAX)

        if randomProbability < mutationRate {

            var randomIdx = generateRandomIndexes(genotypeCount: genotype.count - 1)

            var temp = genotype[randomIdx.1]

            genotype.remove(at: randomIdx.1)

            genotype.insert(temp, at: randomIdx.0 + 1)
        }
    }

    /**
     The scrambleMutation method shuffles a portion of the genes of a Genome object.
     The genotype representation is altered directly, nothing will be returned.

     - parameter mutationRate: Your mutation rate (should be between 0 and 1).
     - parameter genotype: The genotypeRepresentation array of a Genome object.

     */
    open static func scrambleMutation(mutationRate: Float, genotype:inout [Float]) {

        var randomProbability: Float = Float(arc4random()) / Float(UINT32_MAX)

        if randomProbability < mutationRate {

            var randomIdx = generateRandomIndexes(genotypeCount: genotype.count - 1)

            if randomIdx.0 > randomIdx.1 {
                var subset = genotype[randomIdx.1...randomIdx.0].shuffle()

            } else {

                var subset = genotype[randomIdx.0...randomIdx.1].shuffle()
            }
        }
    }

    /**
     The inverseMutation method shuffles a portion of the genes of a Genome object.
     The genotype representation is altered directly, nothing will be returned.

     - parameter genotype: The genotypeRepresentation array of a Genome object.

     */
    open static func inverseMutation(mutationRate: Float, genotype:inout [Float]) {

        var randomProbability: Float = Float(arc4random()) / Float(UINT32_MAX)

        if randomProbability < mutationRate {

            var randomIdx = generateRandomIndexes(genotypeCount: genotype.count - 1)

            if randomIdx.0 > randomIdx.1 {

                genotype[randomIdx.1...randomIdx.0].reverse()

            } else {
                genotype[randomIdx.0...randomIdx.1].reverse()

            }
        }

    }

}
