import Foundation
import Combine

var arr: [Int] = [0, 1, 2]

let toDo: (Int)-> Void = { print($0 * 2) }

example("Subscriber") {
    arr.publisher
        .sink(receiveValue: toDo)
        .store(in: &bag)
}
