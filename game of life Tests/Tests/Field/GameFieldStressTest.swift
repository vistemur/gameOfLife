import XCTest
@testable import game_of_life

final class GameFieldStressTest: XCTestCase {
    
    func testPerformance() {
        let gameField = Field.doubleGlider
        
        let iterations = countIterations(timeout: 10) {
            gameField.getNextGeneration()
        }
        
        print("iterations = \(iterations)")
    }

}
