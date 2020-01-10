import Essentialis
import XCTest

final class FixedLengthArrayTests: XCTestCase {

  func test_init() {
    let array: FixedLengthArray = [1, 2, 3]
    XCTAssertEqual(array.count, 3)
    XCTAssertEqual(array[0], 1)
    XCTAssertEqual(array[1], 2)
    XCTAssertEqual(array[2], 3)
  }

  func test_initRepeating() {
    let array = FixedLengthArray(repeating: 1, count: 3)
    XCTAssertEqual(array.count, 3)
    XCTAssertEqual(array[0], 1)
    XCTAssertEqual(array[1], 1)
    XCTAssertEqual(array[2], 1)
  }

  func test_deinitialize() {
    class A {
      var handler: () -> Void

      init(handler: @escaping () -> Void) {
        self.handler = handler
      }

      deinit {
        handler()
      }
    }

    let exp = self.expectation(description: "test_deinitialize_expectation")
    do {
      let _: FixedLengthArray = [
        A(handler: { exp.fulfill() })
      ]
    }

    waitForExpectations(timeout: 1, handler: nil)
  }

  func test_copy() {
    let array1: FixedLengthArray = [1, 2, 3]
    var array2 = array1
    array2[0] = -1

    XCTAssertEqual(array1.count, 3)
    XCTAssertEqual(array1[0], 1)
    XCTAssertEqual(array1[1], 2)
    XCTAssertEqual(array1[2], 3)

    XCTAssertEqual(array2.count, 3)
    XCTAssertEqual(array2[0], -1)
    XCTAssertEqual(array2[1], 2)
    XCTAssertEqual(array2[2], 3)
  }

  func test_collection() {
    let array: FixedLengthArray = [1, 2, 3]
    XCTAssertEqual(array.reduce(0, +), 6)
  }

  func test_equatable() {
    do {
      let array: FixedLengthArray = [1, 2, 3]
      XCTAssertEqual(array, array)
    }

    do {
      let array: FixedLengthArray = [1, 2, 3]
      var array1 = array
      array1[0] = -1
      XCTAssertNotEqual(array, array1)
    }
  }

  func test_comparable() {
    do {
      let array: FixedLengthArray = [1, 2, 3]
      XCTAssertTrue(array <= array)
    }

    do {
      let array1: FixedLengthArray = [1, 2, 3]
      let array2: FixedLengthArray = [3, 2, 3]
      XCTAssertTrue(array1 <= array2)
      XCTAssertTrue(array1 < array2)
    }
  }

  func test_hashable() {
    let array: FixedLengthArray = [1, 2, 3]
    XCTAssertEqual(array.hashValue, array.hashValue)
  }

}
