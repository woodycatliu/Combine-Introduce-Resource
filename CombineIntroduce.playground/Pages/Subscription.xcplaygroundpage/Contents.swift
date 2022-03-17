import Foundation
import Combine

var arr: [Int] = [0, 1, 2]
var subscription: AnyCancellable? = arr.publisher
    .printValue()

subscription?.cancel()
// or
subscription = nil
