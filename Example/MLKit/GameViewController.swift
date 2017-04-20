//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import SpriteKit
import MachineLearningKit
import Upsurge

extension SKNode {
    class func unarchiveFromFile(_ file: String) -> SKNode? {

        let path = Bundle.main.path(forResource: file, ofType: "sks")

        let sceneData: Data?
        do {
            sceneData = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        } catch _ {
            sceneData = nil
        }
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)

        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

// ADDITIONS

// Genome that represents a Flappy Bird
public class FlappyGenome: Genome {

    /// Genotype representation of the genome.
    public var genotypeRepresentation: [Float]

    public var fitness: Float = 0

    public var brain: NeuralNetwork?

    public init(genotype: [Float], network: NeuralNetwork) {

        self.genotypeRepresentation = genotype
        self.brain = network
    }

    public func generateFitness(score: Int, time: Float) {
        self.fitness = Float(Float(score) + time)
    }
}

// END of ADDITIONS

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create First Generation of Flappy Birds
        var generation1: [FlappyGenome] = []

        for _ in 1...19 {

            // Bias already included
            let brain = NeuralNetwork(size: (6, 1))
            brain.addLayer(layer: Layer(size: (6, 12), activationType: .siglog))
            brain.addLayer(layer: Layer(size: (12, 1), activationType: .siglog))

            let newBird = FlappyGenome(genotype: GeneticOperations.encode(network: brain), network: brain)

            generation1.append(newBird)
        }

        // Best Bird Weights
        let brain = NeuralNetwork(size: (6, 1))
        brain.addLayer(layer: Layer(size: (6, 12), activationType: .siglog))
        brain.addLayer(layer: Layer(size: (12, 1), activationType: .siglog))

        brain.layers[0].weights = Matrix<Float>(rows: 12, columns: 6, elements: ValueArray<Float>([1.14517,	0.691113, -0.938394, 0.798185, -1.20595, 0.732543, 0.174731, -1.0585, -0.500974, -1.02413, 0.841067, -0.530047, -0.336522, -1.68883, -1.47241, 0.907576, 0.71408, 0.646764, -0.331544, 0.141004, 2.42381, 0.0683608, 1.01601, 1.42153, -0.672598, 0.889775, -1.55454, -0.530047, 0.307019, -0.483846, 0.0292488, 0.478605, 0.000960251, -0.379445, -0.336532, -0.17253, 0.892149, -0.301041, 1.06579, -0.230897, 0.39673, -1.93952, 1.69516, 0.185731, -1.48985, -0.17253, -0.336532, -0.379445, 2.12388, 0.0292488, -0.483846, 0.307019, -1.29687, 0.941488, -1.50857, -1.47241, 0.594132, 1.69516, 0.185731, -1.48985, -0.17253, 1.06579, -0.301041, 0.892149, -1.15464, 1.15181, 0.000960251, 0.478605, 0.0292488, -0.483846, 0.307019, -1.29687]))

        brain.layers[1].weights = Matrix<Float>(rows: 1, columns: 12, elements: ValueArray<Float>([1.10186, -1.68883, -0.336522, -2.54774, 0.202769, 1.50816, -3.25252, 0.830278, 0.104464, -1.26191, 0.698875, -0.447793]))

        brain.layers[0].bias = Matrix<Float>(rows: 12, columns: 1, elements: ValueArray<Float>([0.941488, -1.50857, -1.47241, 0.594132, -0.189659, 0.804515, -1.60174, 0.741886, -0.811568, 0.0985006, -0.863954, -0.729362]))
        brain.layers[1].bias = Matrix<Float>(rows: 1, columns: 1, elements: ValueArray<Float>([0.440734]))

        let bestBird =  FlappyGenome(genotype: GeneticOperations.encode(network: brain), network: brain)
        generation1.append(bestBird)


        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {

            // Set the first generation of Flappy Birds
            scene.flappyBirdGenerationContainer = generation1
            scene.maxBird = bestBird

            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsPhysics = true
            skView.showsNodeCount = false

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill

            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
