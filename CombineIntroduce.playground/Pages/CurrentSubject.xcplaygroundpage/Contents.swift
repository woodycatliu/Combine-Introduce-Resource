import Combine

let infailableSubject: CurrentValueSubject<Int, Never> = .init(0)

let failableSubject: CurrentValueSubject<Int, MyError> = .init(0)

func todoClosure<T: Error>(_ subject: CurrentValueSubject<Int, T>)-> (Int)-> () {
    return { (int: Int)-> Void in
        print("newValue:", int, "; subject value:", subject.value)
    }
}

let infailableTodo = todoClosure(infailableSubject)
let failableTodo = todoClosure(failableSubject)

infailableSubject
    .dropFirst()
    .sink(receiveValue: infailableTodo)
    .store(in: &bag)

failableSubject
    .dropFirst()
    .sink(receiveCompletion: {
        print("receiveCompletion:", $0)
    } , receiveValue: failableTodo)
    .store(in: &bag)

example("infailable") {
    infailableSubject.send(1)
    infailableSubject.send(2)
    infailableSubject.send(completion: .finished)
    infailableSubject.send(3) // It won't emit signal
}

example("failable") {
    failableSubject.send(1)
    failableSubject.send(completion: .failure(.someError))
    failableSubject.send(2) // It won't emit signal
    failableSubject.send(completion: .finished) // It won't emit signal
}
