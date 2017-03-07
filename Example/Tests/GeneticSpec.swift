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



    override func spec() {

        it("Should be able to produce a unique genotype after swap mutation process.") {

            var fakeGenome:Genome = Genome(genotype: [1.0,2.0,3.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.swapMutation(genotype: &fakeGenome.genotypeRepresentation)


            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }


        it("Should be able to produce a unique genotype after insert mutation process. ") {

            var fakeGenome:Genome = Genome(genotype: [1.0,2.0,3.0,4.0,5.0,6.0,7.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.insertMutation(genotype: &fakeGenome.genotypeRepresentation)

            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }


        it("Should be able to produce a unique genotype after inverse mutation process. ") {

            var fakeGenome:Genome = Genome(genotype: [1.0,2.0,3.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.inverseMutation(genotype: &fakeGenome.genotypeRepresentation)

            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }

        it("Should be able to produce a unique genotype after scramble mutation process. ") {

            var fakeGenome:Genome = Genome(genotype: [1.0,2.0,3.0,4.0,5.0,6.0,7.0])

            let oldGenotype = fakeGenome.genotypeRepresentation

            BiologicalProcessManager.scrambleMutation(genotype: &fakeGenome.genotypeRepresentation)

            expect(oldGenotype).toNot(equal(fakeGenome.genotypeRepresentation))
        }


    }
    
}
