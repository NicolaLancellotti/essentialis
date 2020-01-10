import Essentialis
import XCTest

final class StackUsingListTests: XCTestCase {

  func test_stack() {
    var stack = StackUsingList<Int>()
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.pop(), nil)

    stack.push(1)
    XCTAssertFalse(stack.isEmpty)

    stack.push(2)
    XCTAssertFalse(stack.isEmpty)

    stack.push(3)
    XCTAssertFalse(stack.isEmpty)

    XCTAssertEqual(stack.pop(), 3)
    XCTAssertFalse(stack.isEmpty)

    XCTAssertEqual(stack.pop(), 2)
    XCTAssertFalse(stack.isEmpty)

    XCTAssertEqual(stack.pop(), 1)
    XCTAssertTrue(stack.isEmpty)

    XCTAssertEqual(stack.pop(), nil)
    XCTAssertTrue(stack.isEmpty)
  }

}
