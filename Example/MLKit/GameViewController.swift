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

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        
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


public struct FlappyGenome: GenomeProtocol {

    public var network: NeuralNet?

    public init(genotype: [Float], network: NeuralNet){

        self.genotypeRepresentation = genotype
        self.network = network
    }

    /// Genotype representation of the genome.
    public var genotypeRepresentation: [Float]

    /// Fitness of a particular genome.
    public var fitness: Float?
    
}




class GameViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()


        // Create First Generation of Flappy Birds

        var generation1:[FlappyGenome] = []

        for _ in 1...10 {

            let brain = NeuralNet()

            brain.initializeNet(numberOfInputNeurons: 4, numberOfHiddenLayers: 1, numberOfNeuronsInHiddenLayer: 4, numberOfOutputNeurons: 1)

            brain.activationFuncType = .SIGLOG

            brain.activationFuncTypeOutputLayer = .SIGLOG

            let newBird = FlappyGenome(genotype: GeneticOperations.encode(network: brain), network: brain)

            generation1.append(newBird)
        }


        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {

            // Set the first generation of Flappy Birds 
            scene.firstGenerationOfFlappyBirds = generation1

            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
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
