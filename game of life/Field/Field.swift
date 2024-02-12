import SwiftUI

@Observable class Field {
    
    private(set) var cells: [[Int]]
    
    var width: Int { cells.first?.count ?? 0 }
    var height: Int { cells.count }
    
    private var swapArray: [[Int]]
    
    init(width: Int = 4, height: Int = 4) {
        self.cells = Array(repeating: Array(repeating: 0, count: width), count: height)
        self.swapArray = Array(repeating: Array(repeating: 0, count: width), count: height)
    }
    
    func setup(cells: [[Int]]) {
        self.cells = cells.map { $0.map { $0 } }
        self.swapArray = cells.map { $0.map { $0 } }
    }
    
    func toggle(_ location: CGPoint) { // from center
        let requiredWidth = abs(location.x * 2)
        var newWidth = CGFloat(width)
        while newWidth <= requiredWidth {
            newWidth *= 2
        }
        
        let requiredHeight = abs(location.y * 2)
        var newHeight = CGFloat(height)
        while newHeight <= requiredHeight {
            newHeight *= 2
        }
        
        if Int(newWidth) > width
            || Int(newHeight) > height {
            cells = resize(cells: cells, newWidth: Int(newWidth), newHeight: Int(newHeight))
            swapArray = Array(repeating: Array(repeating: 0, count: width), count: height)
        }
                
        let x = Int(CGFloat(width) / 2 + location.x)
        let y = Int(CGFloat(height) / 2 + location.y)
        toggle(x: x, y: y)
    }
    
    private func toggle(x: Int, y: Int) {
        guard let value = cells[safe: y]?[safe: x] else {
            return
        }
        
        cells[y][x] = value == 0 ? 1 : 0
    }
    
    func addBorders(cells: [[Int]]) -> [[Int]] {
        var newArray = [[Int]]()
        
        let width = (cells[safe: 0]?.count ?? 0) + 2
        newArray.append(Array(repeating: 0, count: width))
        for y in 0 ..< cells.count {
            var addition = [Int]()
            
            addition.append(0)
            for x in 0 ..< cells[y].count {
                addition.append(cells[y][x])
            }
            addition.append(0)
            
            newArray.append(addition)
        }
        newArray.append(Array(repeating: 0, count: width))
        
        return newArray
    }
    
    func getNextGeneration() {
        var borderTouchedY = false
        var borderTouchedX = false
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                let neighbors = neighborsAmount(cells: cells, y: y, x: x)
                if cells[y][x] == 0 {
                    if neighbors == 3 {
                        swapArray[y][x] = 1
                        borderTouchedX = (x == 0 || x == width - 1) ? true : borderTouchedX
                        borderTouchedY = (y == 0 || y == height - 1) ? true : borderTouchedY
                    } else {
                        swapArray[y][x] = 0
                    }
                } else {
                    if neighbors == 2 || neighbors == 3  {
                        swapArray[y][x] = 1
                        borderTouchedX = (x == 0 || x == width - 1) ? true : borderTouchedX
                        borderTouchedY = (y == 0 || y == height - 1) ? true : borderTouchedY
                    } else {
                        swapArray[y][x] = 0
                    }
                }
            }
        }
        
        if borderTouchedX || borderTouchedY {
            let newWidth = borderTouchedX ? width * 2 : width
            let newHeight = borderTouchedY ? height * 2 : height
            swapArray = resize(cells: swapArray, newWidth: newWidth, newHeight: newHeight)
            cells = Array(repeating: Array(repeating: 0, count: newWidth), count: newHeight)
        }
        
        let swapper = cells
        cells = swapArray
        swapArray = swapper
    }
    
    private func neighborsAmount(cells: [[Int]], y: Int, x: Int) -> Int {
        var neighbors = 0
        
        neighbors += (cells[safe: y - 1] ?? [])[safe: x - 1] ?? 0
        neighbors += (cells[safe: y - 1] ?? [])[safe: x] ?? 0
        neighbors += (cells[safe: y - 1] ?? [])[safe: x + 1] ?? 0
        
        neighbors += (cells[safe: y] ?? [])[safe: x - 1] ?? 0
        neighbors += (cells[safe: y] ?? [])[safe: x + 1] ?? 0
        
        neighbors += (cells[safe: y + 1] ?? [])[safe: x - 1] ?? 0
        neighbors += (cells[safe: y + 1] ?? [])[safe: x] ?? 0
        neighbors += (cells[safe: y + 1] ?? [])[safe: x + 1] ?? 0
        
        return neighbors
    }
    
    private func resize(cells: [[Int]], newWidth: Int, newHeight: Int) -> [[Int]] {
        let width = cells.first?.count ?? 0
        let height = cells.count
        var newCells = [[Int]]()
        
        for _ in 1 ... newHeight {
            let row = Array(repeating: 0, count: newWidth)
            newCells.append(row)
        }
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                newCells[newHeight / 2 - height / 2 + y][newWidth / 2 - width / 2 + x] = cells[y][x]
            }
        }
        
        return newCells
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
