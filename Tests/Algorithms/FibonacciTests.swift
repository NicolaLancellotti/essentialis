import Essentialis
import XCTest

final class FibonacciTests: XCTestCase {

  func test_fibIterative() {
    XCTAssertEqual(Fibonacci.fibIterative(1), 1)
    XCTAssertEqual(Fibonacci.fibIterative(2), 1)
    XCTAssertEqual(Fibonacci.fibIterative(3), 2)
    XCTAssertEqual(Fibonacci.fibIterative(4), 3)
    XCTAssertEqual(Fibonacci.fibIterative(5), 5)
    XCTAssertEqual(Fibonacci.fibIterative(6), 8)
    XCTAssertEqual(Fibonacci.fibIterative(7), 13)
  }

  func test_fibMatrix() {
    XCTAssertEqual(Fibonacci.fibMatrix(1), 1)
    XCTAssertEqual(Fibonacci.fibMatrix(2), 1)
    XCTAssertEqual(Fibonacci.fibMatrix(3), 2)
    XCTAssertEqual(Fibonacci.fibMatrix(4), 3)
    XCTAssertEqual(Fibonacci.fibMatrix(5), 5)
    XCTAssertEqual(Fibonacci.fibMatrix(6), 8)
    XCTAssertEqual(Fibonacci.fibMatrix(7), 13)
  }

}
