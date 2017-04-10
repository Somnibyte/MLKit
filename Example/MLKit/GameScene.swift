//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit
import MachineLearningKit
import Upsurge

class GameScene: SKScene, SKPhysicsContactDelegate {

    // ADDITIONS

    /// Container for our Flappy Birds
    var flappyBirdGenerationContainer: [FlappyGenome]?

    /// The current genome
    var currentBird: FlappyGenome?

    /// The current flappy bird of the current generation (see 'generationCounter' variable)
    var currentFlappy: Int = 0

    /// Variable used to count the number of generations that have passed
    var generationCounter = 1

    /// Variable to keep track of the current time (this is used to determine fitness later)
    var currentTimeForFlappyBird = NSDate()

    /// The red square (our goal area)
    var goalArea: SKShapeNode!

    /// The pipe that is in front of the bird
    var currentPipe: Int = 0

    /// The fitness of the best bird
    var maxFitness: Float = 0

    /// The best bird (from any generation)
    var maxBird: FlappyGenome?

    /// The best birds from the previous generation
    var lastBestGen: [FlappyGenome] = []

    /// SKLabel
    var generationLabel: SKLabelNode!
    var fitnessLabel: SKLabelNode!

    let groundTexture = SKTexture(imageNamed: "land")

    /// Best score (regardless of generation)
    var bestScore: Int = 0


    /// Label that displays the best score (bestScore attribute)
    var bestScoreLabel: SKLabelNode!


    // END of ADDITIONS

    let verticalPipeGap = 150.0
    var bird: SKSpriteNode!
    var skyColor: SKColor!
    var pipeTextureUp: SKTexture!
    var pipeTextureDown: SKTexture!
    var movePipesAndRemove: SKAction!
    var moving: SKNode!
    var pipes: SKNode!
    var canRestart = Bool()
    var scoreLabelNode: SKLabelNode!
    var score = NSInteger()

    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3

    override func didMove(to view: SKView) {

        canRestart = false

        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
        self.physicsWorld.contactDelegate = self

        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor

        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)

        // ground

        groundTexture.filteringMode = .nearest // shorter form for SKTextureFilteringMode.Nearest

        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))

        for i in 0 ..< 2 + Int(self.frame.size.width / ( groundTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.run(moveGroundSpritesForever)
            moving.addChild(sprite)
        }

        // skyline
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest

        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite, resetSkySprite]))

        for i in 0 ..< 2 + Int(self.frame.size.width / ( skyTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
            moving.addChild(sprite)
        }

        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .nearest

        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])

        // spawn the pipes
        let spawn = SKAction.run(spawnPipes)
        let delay = SKAction.wait(forDuration: TimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        self.run(spawnThenDelayForever)

        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = .nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = .nearest

        let anim = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(anim)

        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        bird.run(flap)

        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false

        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory

        self.addChild(bird)

        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)

        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)


        bestScore = 0
        bestScoreLabel = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        bestScoreLabel.position = CGPoint( x: self.frame.midX - 120.0, y: 3 * self.frame.size.height / 4 + 110.0 )
        bestScoreLabel.zPosition = 100
        bestScoreLabel.text = "bestScore: \(self.bestScore)"
        self.addChild(bestScoreLabel)

        generationLabel = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        generationLabel.position = CGPoint( x: self.frame.midX - 150.0, y: 3 * self.frame.size.height / 4 + 140.0 )
        generationLabel.zPosition = 100
        generationLabel.text = "Gen: 1"
        self.addChild(generationLabel)

        fitnessLabel = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        fitnessLabel.position = CGPoint( x: self.frame.midX + 110.0, y: 3 * self.frame.size.height / 4 + 140.0 )
        fitnessLabel.zPosition = 100
        fitnessLabel.text = "Fitness: 0"
        self.addChild(fitnessLabel)

        // Set the current bird
        if let generation = flappyBirdGenerationContainer {
            currentBird = generation[currentFlappy]
        }

    }

    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
        pipePair.zPosition = -10

        let height = UInt32( self.frame.size.height / 4)
        let y = Double(arc4random_uniform(height) + height)

        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.name = "DOWN"
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)

        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)

        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x: 0.0, y: y)

        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory

        // ADDITIONS
        goalArea = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
        goalArea.name = "GOAL"
        goalArea.fillColor = SKColor.red
        goalArea.position = pipeUp.position
        goalArea.position.y += 250
        // END of ADDITIONS

        pipePair.addChild(pipeUp)
        pipePair.addChild(goalArea)

        let contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeDown.size.width + bird.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)

        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)

    }

    func resetScene () {

        // Move bird to original position and reset velocity
        bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
        bird.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0

        // Remove all existing pipes
        pipes.removeAllChildren()

        // Reset _canRestart
        canRestart = false

        // Reset score
        score = 0
        scoreLabelNode.text = String(score)

        // Restart animation
        moving.speed = 1

        // GENETIC ALGORITHM (DOWN BELOW)

        // Calculate the amount of time it took until the AI lost.
        let endDate: NSDate = NSDate()
        let timeInterval: Double = endDate.timeIntervalSince(currentTimeForFlappyBird as Date)
        currentTimeForFlappyBird = NSDate()

        // Evaluate the current birds fitness
        if let bird = currentBird {
            bird.generateFitness(score: score, time: Float(timeInterval))

            // Current generation, bird, and fitness of current bird information
            print("--------------------------- \n")
            print("GENERATION: \(generationCounter)")
            print("BIRD COUNT: \(currentFlappy)")
            print("FITNESS: \(bird.fitness)")
            self.generationLabel.text = "Gen: \(self.generationCounter)"
            print("--------------------------- \n")

            if bird.fitness >= 9.0 {
                print("FOUND RARE BIRD")
                print(bird.brain?.layers[0].weights)
                print(bird.brain?.layers[1].weights)
                print(bird.brain?.layers[0].bias)
                print(bird.brain?.layers[1].bias)
            }
        }

        // Go to next flappy bird
        currentFlappy += 1

        if let generation = flappyBirdGenerationContainer {
            // Experiment: Keep some of the last best birds and put them back into the population
            lastBestGen = generation.filter({$0.fitness >= 6.0})

            if lastBestGen.count > 10 {
                // We want to make room for unique birds
                lastBestGen = Array<FlappyGenome>(lastBestGen[0...6])
            }
        }

        if let bird = currentBird {
            if bird.fitness > maxFitness {
                maxFitness = bird.fitness
                maxBird = bird
            }
        }

        // If we have hit the 20th bird, we need to move on to the next generation
        if currentFlappy == 20 {

            print("GENERATING NEW GEN!")

            currentFlappy = 0

            // New generation array
            var newGen: [FlappyGenome] = []

            newGen = lastBestGen

            if let bestBird = maxBird {
                flappyBirdGenerationContainer?.append(bestBird)
            }

            while newGen.count < 20 {

                // Select the best parents
                let parents = PopulationManager.selectParents(genomes: flappyBirdGenerationContainer!)

                print("PARENT 1 FITNESS: \(parents.0.fitness)")
                print("PARENT 2 FITNESS: \(parents.1.fitness)")

                // Produce new flappy birds
                var offspring = BiologicalProcessManager.onePointCrossover(crossoverRate: 0.5, parentOneGenotype: parents.0.genotypeRepresentation, parentTwoGenotype: parents.1.genotypeRepresentation)

                // Mutate their genes
                BiologicalProcessManager.inverseMutation(mutationRate: 0.7, genotype: &offspring.0)
                BiologicalProcessManager.inverseMutation(mutationRate: 0.7, genotype: &offspring.1)


                // Create a separate neural network for the birds based on their genes
                let brainofOffspring1 = GeneticOperations.decode(genotype: offspring.0)

                let brainofOffspring2 = GeneticOperations.decode(genotype: offspring.1)

                let offspring1 = FlappyGenome(genotype: offspring.0, network: brainofOffspring1)

                let offspring2 = FlappyGenome(genotype: offspring.1, network: brainofOffspring2)

                // Add them to the new generation
                newGen.append(offspring1)

                newGen.append(offspring2)

            }

            generationCounter += 1

            // Replace the old generation
            flappyBirdGenerationContainer = newGen

            // Set the current bird

            if let generation = flappyBirdGenerationContainer {
                if generation.count > currentFlappy{
                    currentBird = generation[currentFlappy]
                }else{
                    if let bestBird = maxBird {
                        currentBird = maxBird
                    }
                }
            }

        } else {

            // Set the current bird
            if let generation = flappyBirdGenerationContainer {
                if generation.count > currentFlappy {
                    currentBird = generation[currentFlappy]
                }
            }else{
                currentBird = maxBird
            }

        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if moving.speed > 0 {
            for _ in touches { // do we need all touches?

            }
        } else if canRestart {
            self.resetScene()
        }
    }

    // Chooses the closest pipe
    func closestPipe(pipes: [SKNode]) -> Int {

        var min = 0
        var minDist = abs(pipes[0].position.x - bird.position.x)

        for (i, pipe) in pipes.enumerated() {
            if abs(pipe.position.x - minDist) < minDist {
                minDist = abs(pipe.position.x - minDist)
                min = i
            }
        }

        return min
    }

    override func update(_ currentTime: TimeInterval) {

        let endDate: NSDate = NSDate()
        let timeInterval: Double = endDate.timeIntervalSince(currentTimeForFlappyBird as Date)
        self.fitnessLabel.text = "Fitness: \(NSString(format: "%.2f", timeInterval))"

        checkIfOutOfBounds(bird.position.y)

        /* Called before each frame is rendered */
        let value = bird.physicsBody!.velocity.dy * ( bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 )
        bird.zRotation = min( max(-1, value), 0.5 )

        // If the pipes are now visible...
        if pipes.children.count > 0 {

            // Check to see if the pipe in front has gone behind the bird
            // if so, make the new pipe in front of the bird the target pipe
            if pipes.children[currentPipe].position.x < bird.position.x {

                currentPipe = closestPipe(pipes: pipes.children)
            }

            // Distance between next pipe and bird
            let distanceOfNextPipe = abs(pipes.children[currentPipe].position.x - bird.position.x)

            let distanceFromBottomPipe = abs(pipes.children[currentPipe].children[1].position.y - bird.position.y)

            let normalizedDistanceFromBottomPipe = (distanceFromBottomPipe - 5)/(708 - 5)

            let normalizedDistanceOfNextPipe = (distanceOfNextPipe - 3)/(725-3)

            let distanceFromTheGround = abs(self.bird.position.y - self.moving.children[1].position.y)

            let normalizedDistanceFromTheGround = (distanceFromTheGround - 135)/(840-135)

            let distanceFromTheSky = abs(880 - self.bird.position.y)

            let normalizedDistanceFromTheSky = distanceFromTheSky/632



            // Bird Y position
            let birdYPos = bird.position.y/CGFloat(880)

            // Measure how close the bird is to the gap between the pipes
            let posToGap = pipes.children[0].children[2].position.y - bird.position.y

            let normalizedPosToGap = (posToGap - (-439))/(279 - (-439))

            if let flappyBird = currentBird {

                // Decision AI makes
                let input = Matrix<Float>(rows: 6, columns: 1, elements: [Float(normalizedDistanceOfNextPipe), Float(normalizedPosToGap), Float(birdYPos), Float(normalizedDistanceFromBottomPipe), Float(normalizedDistanceFromTheGround), Float(normalizedDistanceFromTheSky)])
                let potentialDescision = flappyBird.brain?.feedforward(input: input)


                if let decision = potentialDescision {

                    print("FLAPPY BIRD DECISION: \(decision)")

                    if  (decision.elements[0]) >= Float(0.5) {

                        if moving.speed > 0 {

                            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))

                        }
                        
                    }
                }

            }

        }

        if canRestart {

            // If the game ends...
            // record the current flappy birds fitness...
            // then bring in the next flappy bird

            self.resetScene()
        }

    }

    // Checks if the bird is at the top of the screen
    func checkIfOutOfBounds(_ y: CGFloat) {

        if moving.speed > 0 {

            if y >= 880 {
                moving.speed = 0

                bird.physicsBody?.collisionBitMask = worldCategory
                bird.run(  SKAction.rotate(byAngle: CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion: {self.bird.speed = 0 })

                // Flash background if contact is detected
                self.removeAction(forKey: "flash")
                self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                    //self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                }), SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                    self.backgroundColor = self.skyColor
                }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                    self.canRestart = true
                })]), withKey: "flash")
            }

        }

    }

    func didBegin(_ contact: SKPhysicsContact) {

        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Bird has contact with score entity
                score += 1
                scoreLabelNode.text = String(score)

                // Update best score label
                if score > bestScore {
                    bestScore = score
                    bestScoreLabel.text = "Best Score: \(self.bestScore)"
                }

                // Add a little visual feedback for the score increment
                scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
            } else {

                moving.speed = 0

                bird.physicsBody?.collisionBitMask = worldCategory
                bird.run(  SKAction.rotate(byAngle: CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion: {self.bird.speed = 0 })

                // Flash background if contact is detected
                self.removeAction(forKey: "flash")
                self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                    //self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                }), SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                    self.backgroundColor = self.skyColor
                }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                    self.canRestart = true
                })]), withKey: "flash")
            }
        }
    }
}
