import Combine

let infailableSubject = PassthroughSubject<Int, Never> ()

let failableSubject = PassthroughSubject<Int, MyError>()

let intClosure: (Int)-> Void = {
    print("newValue:", $0)
}

infailableSubject
    .sink(receiveValue: intClosure)
    .store(in: &bag)

failableSubject
    .sink(receiveCompletion: {
        print("receiveCompletion:", $0)
    } , receiveValue: intClosure)
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


