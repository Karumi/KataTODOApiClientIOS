import Combine
import Nimble

private extension DispatchTimeInterval {
    static var defaultGetTimeout: DispatchTimeInterval { .seconds(30) }
}

extension AnyPublisher {
    static var neverPublishing: Self { Future { _ in }.eraseToAnyPublisher() }
  
    static func fail(_ failure: Failure) -> Self {
        Fail(outputType: Output.self, failure: failure).eraseToAnyPublisher()
    }
    
    static func just(_ output: Output) -> Self {
        Just(output).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
    
    func get(timeout: DispatchTimeInterval = .defaultGetTimeout) throws -> [Output] {
        var subscriptions = Set<AnyCancellable>()
        var output: [Output] = []
        var error: Error?
    
        waitUntil(timeout: timeout) { done in
            self.sink(receiveCompletion: {
                if case let .failure(receivedError) = $0 {
                    error = receivedError
                }
                done()
            }, receiveValue: { value in
                output.append(value)
            }).store(in: &subscriptions)
        }
        
        if let err = error { throw err }
        return output
    }
    
}
