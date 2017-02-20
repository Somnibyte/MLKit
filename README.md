# [WIP] MLKit (a.k.a Machine Learning Kit) 🤖
MLKit is a simple machine learning framework written in Swift. Currently MLKit features machine learning algorithms that deal with the topic of regression, but the framework will expand over time with topics such as classification, clustering, recommender systems, and deep learning. The vision and goal of this framework is to provide developers with a toolkit to create products that can learn from data. MLKit is a side project of mine in order to make it easier for developers to implement machine learning algorithms on the go, and to familiarlize myself with machine learning concepts.

[![CI Status](http://img.shields.io/travis/Guled Ahmed/MLKit.svg?style=flat)](https://travis-ci.org/Guled Ahmed/MLKit)
[![Version](https://img.shields.io/cocoapods/v/MLKit.svg?style=flat)](https://cocoapods.org/pods/MachineLearningKit)
[![License](https://img.shields.io/cocoapods/l/MLKit.svg?style=flat)](https://cocoapods.org/pods/MachineLearningKit)
[![Platform](https://img.shields.io/cocoapods/p/MLKit.svg?style=flat)](https://cocoapods.org/pods/MachineLearningKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MLKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MachineLearningKit', '0.1.1'
```

## Wiki 

- [x] [Simple Linear Regression (1 Feature)](https://github.com/Somnibyte/MLKit/wiki/Simple-Linear-Regression-Tutorial)

## Features (So Far)

- [x] Matrix and Vector Operations (uses [Upsurge framework](https://github.com/aleph7/Upsurge))
- [x] Simple Linear Regression (Allows for 1 feature set)
- [x] Polynomial Regression (Allows for multiple features)
- [x] Ridge Regression
- [x] Allows for splitting your data into training, validation, and test sets.
- [x] K-Fold Cross Validation & Ability to test various L2 penalties for Ridge Regression

## Frameworks that MLKit uses

- 🙌 [Upsurge](https://github.com/aleph7/Upsurge) (Matrix and Vector Operations)
- 🙌 [CSVReader](https://github.com/peterentwistle/SwiftCSVReader) (CSV Reading) (Used in Unit Testing)

## Development Schedule

### Week of Feb 20th
|M|T|W|Th|F|
|---|---|---|---|---|
|K-Means Clustering|K-Means Clustering|TBD|TBD|TBD|


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
