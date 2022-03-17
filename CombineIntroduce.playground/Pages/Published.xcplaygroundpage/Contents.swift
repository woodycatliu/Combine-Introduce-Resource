import Foundation
import Combine

/**
 public class PublishedContainer<T> {
     @Published
     public var value: T
     public init(value: T) {
         self.value = value
     }
 }
 */


let publishedContainer: PublishedContainer<Int> = .init(value: 0)

let intClosure: (Int)-> Void = {
    print("newValue:", $0, "。 container value:", publishedContainer.value)
}

publishedContainer.$value
    .dropFirst()
    .sink(receiveValue: intClosure)
    .store(in: &bag)

example("Published") {
    publishedContainer.value = 1
    publishedContainer.value = 2
}


