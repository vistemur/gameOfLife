import XCTest
@testable import game_of_life

final class FieldTests: XCTestCase {
    
    // FieldProtocol
    
    func testSetup() {
        let cells = Array(repeating: Array(repeating: 1, count: 11), count: 10)
        
        let field = Field()
        field.setup(cells: cells)
        print(field)
    }
    
    func testToggle() {
    }

    func testCopy() {
    }
    
    func testGetNextGeneration() {
    }
}
