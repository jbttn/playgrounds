struct Matrix {
    let rows: Int, columns: Int
    var flatGrid: [Int]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.flatGrid = Array(count: rows * columns, repeatedValue: 0)
    }
    
    subscript(row: Int, column: Int) -> Int {
        get {
            return self.flatGrid[(row * self.columns) + column]
        }
        set {
            self.flatGrid[(row * self.columns) + column] = newValue
        }
    }
}

struct Position {
    var row = 0
    var column = 0
}

class Navigator {
    let directionsBeforeStepIncrease = 2
    /// Keeps track of how many directions we can travel until we need to increase the maximum number of steps we can take for each direction
    var directionCount: Int
    /// The maximum number of steps we can take in the current direction before we need to turn
    var maxSteps: Int
    /// The current number of steps we have taken in the current direction
    var currentDirectionSteps: Int
    /// The direction we are currently traveling
    var currentDirection: Direction
    /// Our position in the grid
    var currentPosition: Position
    
    enum Direction {
        case Up
        case Down
        case Left
        case Right
    }
    
    init(startingPosition: Position) {
        directionCount = directionsBeforeStepIncrease
        maxSteps = 1
        currentDirectionSteps = 0
        currentDirection = .Right
        currentPosition = startingPosition
    }
    
    func step() {
        switch currentDirection {
            case .Up:
                currentPosition.row = currentPosition.row - 1
            case .Down:
                currentPosition.row = currentPosition.row + 1
            case .Left:
                currentPosition.column = currentPosition.column - 1
            case .Right:
                currentPosition.column = currentPosition.column + 1
        }
        
        // We made a step
        currentDirectionSteps++
        
        // If we have reached the maximum number of steps for this direction...
        if (currentDirectionSteps == maxSteps) {
            setNextDirection()
            currentDirectionSteps = 0
            
            // If the direction counter reaches 0 then we need to increase the number of steps we can take for the next direction
            if (directionCount <= 0) {
                directionCount = directionsBeforeStepIncrease
                maxSteps++
            }
        }
    }
    
    /// Decrement the direction counter and set the new direction
    private func setNextDirection() {
        directionCount--
        switch currentDirection {
            case .Up:
                currentDirection = .Left
            case .Down:
                currentDirection = .Right
            case .Left:
                currentDirection = .Down
            case .Right:
                currentDirection = .Up
        }
    }
}

class SpiralGenerator {
    var matrix: Matrix
    var navigator: Navigator
    let startingLength: Int
    
    init(length: Int, matrixSize: Int) {
        assert(matrixSize % 2 != 0, "Matrix size must be an odd number")
        
        var startingPosition = Position(row: matrixSize / 2, column: matrixSize / 2)
        
        matrix = Matrix(rows: matrixSize, columns: matrixSize)
        navigator = Navigator(startingPosition: startingPosition)
        startingLength = length
        if (startingLength > matrix.rows * matrix.columns) {
            startingLength = matrix.rows * matrix.columns
        }
    }
    
    func generate() -> Void {
        spiral(1)
        printSpiral()
    }
    
    private func spiral(length: Int) {
        if (length <= startingLength) {
            matrix[navigator.currentPosition.row, navigator.currentPosition.column] = length
            navigator.step()
            let newLength = length + 1
            spiral(newLength)
        }
    }
    
    private func printSpiral() {
        for row in 0...matrix.rows-1 {
            for column in 0...matrix.columns-1 {
                var num = matrix[row, column]
                if (num != 0) {
                    if (num < 10) {
                        print(" 0\(num) ")
                    } else {
                        print(" \(num) ")
                    }
                } else {
                    print(" XX ")
                }
            }
            print("\n\n")
        }
    }
}

var spiral = SpiralGenerator(length:81, matrixSize: 9)
spiral.generate()
