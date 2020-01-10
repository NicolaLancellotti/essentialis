import Essentialis
import XCTest

final class FixedLengthQueueTests: XCTestCase {

  func test_queue() {
    var queue = FixedLengthQueue<Int>(count: 2)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertFalse(queue.isFull)

    XCTAssertNil(queue.dequeue())

    XCTAssertNoThrow(try queue.enqueue(1))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertFalse(queue.isFull)

    XCTAssertNoThrow(try queue.enqueue(2))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertTrue(queue.isFull)

    XCTAssertThrowsError(try queue.enqueue(3))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertTrue(queue.isFull)

    XCTAssertEqual(queue.dequeue(), 1)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertFalse(queue.isFull)

    XCTAssertEqual(queue.dequeue(), 2)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertFalse(queue.isFull)

    XCTAssertNil(queue.dequeue())
    XCTAssertTrue(queue.isEmpty)
    XCTAssertFalse(queue.isFull)

    XCTAssertNoThrow(try queue.enqueue(3))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertFalse(queue.isFull)

    XCTAssertEqual(queue.dequeue(), 3)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertFalse(queue.isFull)
  }

}
