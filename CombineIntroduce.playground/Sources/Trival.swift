import Combine

public var bag: Set<AnyCancellable> = []

public class PublishedContainer<T> {
    @Published
    public var value: T
    public init(value: T) {
        self.value = value
    }
}

public let example: ((String), _ completion: @escaping ()->()) ->() = { str, completion in
    print("------ \(str) Begin")
    completion()
    print("------ End ------")
}


extension Publisher where Failure == Never {
   public func printValue()-> AnyCancellable {
        return sink(receiveValue: { Swift.print("\($0)") })
    }
}
