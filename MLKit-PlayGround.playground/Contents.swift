//: Playground - noun: a place where people can play

import UIKit
import MachineLearningKit

// Slicing 
struct test {
    var testArray:[Int] = [1,2,3,4,5,6,7,8]
}

var t = test()

func swapMutation( genotype:inout [Int]) {
    genotype[0] = genotype[1]

}


extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}


//t.testArray[0...3].shuffle()
print(t.testArray)
print(t.testArray[0...3].reverse())
print(t.testArray)