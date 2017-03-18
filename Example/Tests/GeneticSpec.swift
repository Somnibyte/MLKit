//
//  GeneticSpec.swift
//  MLKit
//
//  Created by Guled  on 3/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Upsurge
import MachineLearningKit
import Quick
import Nimble


class GeneticSpec: QuickSpec {


    public struct FakeGenome: Genome {

        var genotypeRepresentation: [Float]

        var fitness: Float

        public init(genotype: [Float]) {

            self.genotypeRepresentation = genotype
            self.fitness = 0
        }

    }


    override func spec() {

        it("Should be able to produce a unique genotype after a one-point crossover process.") {
            // Create a population of two individuals
            let fakeGenome1: FakeGenome = FakeGenome(genotype: [1.0, 2.0, 3.0])
            let fakeGenome2: FakeGenome = FakeGenome(genotype: [4.0, 5.0, 6.0])

            let newGenomes = BiologicalProcessManager.onePointCrossover(crossOverRate: 1.0, parentOneGenotype: fakeGenome1.genotypeRepresentation, parentTwoGenotype: fakeGenome2.genotypeRepresentation)

            expect(newGenomes.0).toNot(equal(fakeGenome1.genotypeRepresentation))
            expect(newGenomes.1).toNot(equal(fakeGenome2.genotypeRepresentation))

        }

        it("Should be able to produce a unique genotype after swap mutation process.") {

            var fakeGenome: FakeGenome = FakeGenome(genotype: [1.0, 2.0, 3.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.swapMutation(mutationRate: 1.0, genotype: &fakeGenome.genotypeRepresentation )


            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }


        it("Should be able to produce a unique genotype after insert mutation process. ") {

            var fakeGenome: FakeGenome = FakeGenome(genotype: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.insertMutation(mutationRate: 1.0, genotype: &fakeGenome.genotypeRepresentation )

            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }


        it("Should be able to produce a unique genotype after inverse mutation process. ") {

            var fakeGenome: FakeGenome = FakeGenome(genotype: [1.0, 2.0, 3.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.inverseMutation(mutationRate: 1.0, genotype: &fakeGenome.genotypeRepresentation )

            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }

        it("Should be able to produce a unique genotype after scramble mutation process. ") {

            var fakeGenome: FakeGenome = FakeGenome(genotype: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.scrambleMutation(mutationRate: 1.0, genotype: &fakeGenome.genotypeRepresentation)

            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }



    }

}
