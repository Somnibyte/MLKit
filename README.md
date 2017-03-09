![](https://github.com/Somnibyte/MLKit/blob/master/MLKitSmallerLogo.png)

# [WIP] MLKit (a.k.a Machine Learning Kit) 🤖
MLKit is a simple machine learning framework written in Swift. Currently MLKit features machine learning algorithms that deal with the topic of regression, but the framework will expand over time with topics such as classification, clustering, recommender systems, and deep learning. The vision and goal of this framework is to provide developers with a toolkit to create products that can learn from data. MLKit is a side project of mine in order to make it easier for developers to implement machine learning algorithms on the go, and to familiarlize myself with machine learning concepts.

[![Version](https://img.shields.io/cocoapods/v/MLKit.svg?style=flat)](https://cocoapods.org/pods/MachineLearningKit)
[![License](https://img.shields.io/cocoapods/l/MLKit.svg?style=flat)](https://cocoapods.org/pods/MachineLearningKit)
[![Platform](https://img.shields.io/cocoapods/p/MLKit.svg?style=flat)](https://cocoapods.org/pods/MachineLearningKit)

[MachineLearningKit Reference](http://cocoadocs.org/docsets/MachineLearningKit/0.1.4/index.html)

## Requirements

## Installation

MLKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MachineLearningKit', '0.1.4'
```


----------------------------------------------

## Contributing 
The mission of this project is to give developers the ability to incorporate Machine Learning algorithms into their projects with ease and to enable the creation of advanced projects using the Swift programing language. With this being said, I encourage all developers interested in making Machine Learning accessible to the anyone who works with iOS apps and TVOS apps to contribute to this project. 

To contribute an algorithm **not** currently available within the framework, please create an issue and state what algorithm you have implemented. Make sure that there are unit tests involved where applicable. Also, provide a brief overview of how to use your algorithm. You are also welcome to impelment algorithms within the **Roadmap** section (below). 

To contribute to an already existant algorithm within the framework, please create an issue and state any changes or additions you have made.

----------------------------------------------

## Wiki 

- [x] [Simple Linear Regression (1 Feature)](https://github.com/Somnibyte/MLKit/wiki/Simple-Linear-Regression-Tutorial)
- [x] [Polynomial Regression](https://github.com/Somnibyte/MLKit/wiki/Polynomial-Regression-Tutorial)
- [x] [Lasso Regression] (https://github.com/Somnibyte/MLKit/wiki/Lasso-Regression-Tutorial)
- [x] [Ridge Regression] (https://github.com/Somnibyte/MLKit/wiki/Ridge-Regression-Tutorial)
- [x] [Neural Network AND logic Example](https://github.com/Somnibyte/MLKit/wiki/Neural-Network-AND-logic-Example)


## Example Project 
![](https://github.com/Somnibyte/MLKit/blob/master/flappybirdai.gif)

⚠️️  The Flappy Bird Example Project is located in the `Example` folder. When you run the example you will see the fitness and the decisions that each Flappy Bird is making. The example project has comments to help with understanding how it was made. More improvements to the documentation for the example project and the genetic algorithm classes coming soon. 

- [ ] Genetic Algorithm & Flappy Bird Example Explanation (**Coming Soon**) 



----------------------------------------------

### Roadmap:

- [ ] KMeans++ Implementation 
- [ ] KMeans Clustering Documentation
- [ ] Neural Network Documentation 
- [ ] Enable Neural Network class to allow for multiple hidden layers (currently 1 is only allowed)
- [ ] Logistic Regression
- [ ] Genetic Algorithms
- [ ] Self Organizing Maps
- [ ] Decision Trees 

### Future Releases:
- [ ] Convolutional Neural Network 
- [ ] Recurrent Neural Network 
- [ ] Artificial Neural Network using Metal
- [ ] Game Playing AI (MiniMax, Alpha-Beta Pruning)

----------------------------------------------
## Features (So Far)

- [x] Matrix and Vector Operations (uses [Upsurge framework](https://github.com/aleph7/Upsurge))
- [x] Simple Linear Regression (Allows for 1 feature set)
- [x] Polynomial Regression (Allows for multiple features)
- [x] Ridge Regression
- [x] Neural Network (/w BackPropagation, Single Layer Perceptron, Multi-Layer Perceptron (1 Hidden Layer limit), and Single Layer Adaline
- [x] K-Means Clustering 
- [x] Allows for splitting your data into training, validation, and test sets.
- [x] K-Fold Cross Validation & Ability to test various L2 penalties for Ridge Regression
- [x] Single Layer Perceptron, Multi-Layer Perceptron, & Adaline ANN Architectures 

----------------------------------------------

## Frameworks that MLKit uses

- 🙌 [Upsurge](https://github.com/aleph7/Upsurge) (Matrix and Vector Operations)
- 🙌 [CSVReader](https://github.com/peterentwistle/SwiftCSVReader) (CSV Reading) (Used in Unit Testing)

----------------------------------------------

## Development Schedule

### Week of Mar 6th
|M|T|W|Th|F|
|---|---|---|---|---|
|Neural Network Documentation, K-Means Documentation, Decision Trees|Genetic Algorithm|Genetic Algorithm + Neural Network Example|Flappy Bird Example|Flappy Bird Example Improvements & Genetic Algorithm Improvements 

----------------------------------------------

# License
MIT License

Copyright (c) 2016 Guled Ahmed

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
