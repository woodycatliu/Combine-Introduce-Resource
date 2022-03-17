import Foundation
import Combine

var arr: [Int] = [0, 1, 2]
var str: String = "ABCD"
var int: Int = 1000

example("arr") {
    arr.publisher.printValue().store(in: &bag)
}

example("str") {
    str.publisher.printValue().store(in: &bag)
}

example("int") {
    int.words.publisher.printValue().store(in: &bag)
}
