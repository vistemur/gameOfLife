import XCTest

extension XCTestCase {
    
    func countIterations(timeout: TimeInterval,
                         _ workItem: @escaping () -> Void) -> Int {
        let executionQueue = OperationQueue()
        let completionQueue = OperationQueue()
        var iterations = 0
        
        let operation = {
            while true {
                workItem()
                iterations += 1
            }
        }
        executionQueue.addOperation(operation)
        
        let expectation = XCTestExpectation()
        completionQueue.schedule(after: .init(.now + timeout)) {
            executionQueue.cancelAllOperations()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout + 1)
        
        return iterations
    }
    
}
