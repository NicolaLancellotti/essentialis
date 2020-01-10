import Essentialis
import XCTest

final class QueueUsingListTests: XCTestCase {

  func test_queue() {
    var queue = QueueUsingList<Int>()
    XCTAssertTrue(queue.isEmpty)

    XCTAssertNil(queue.dequeue())

    queue.enqueue(1)
    XCTAssertFalse(queue.isEmpty)

    queue.enqueue(2)
    XCTAssertFalse(queue.isEmpty)

    queue.enqueue(3)
    XCTAssertFalse(queue.isEmpty)

    XCTAssertEqual(queue.dequeue(), 1)
    XCTAssertFalse(queue.isEmpty)

    XCTAssertEqual(queue.dequeue(), 2)
    XCTAssertFalse(queue.isEmpty)

    queue.enqueue(4)
    XCTAssertFalse(queue.isEmpty)

    XCTAssertEqual(queue.dequeue(), 3)
    XCTAssertFalse(queue.isEmpty)

    XCTAssertEqual(queue.dequeue(), 4)
    XCTAssertTrue(queue.isEmpty)

    XCTAssertNil(queue.dequeue())
    XCTAssertTrue(queue.isEmpty)
  }
}
