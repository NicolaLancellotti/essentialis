import Essentialis
import XCTest

final class SortTests: XCTestCase {

  func test_selectionSort() {
    sharedTest { collection in
      Sort.selectionSort(&collection)
    }
  }

  func test_insertionSort() {
    sharedTest { collection in
      Sort.insertionSort(&collection)
    }
  }

  func test_bubbleSort() {
    sharedTest { collection in
      Sort.bubbleSort(&collection)
    }
  }

  func test_heapSort() {
    sharedTest { collection in
      Sort.heapSort(&collection)
    }
  }

  func test_mergeSort() {
    sharedTest { collection in
      Sort.mergeSort(&collection)
    }
  }

  func test_quickSort() {
    sharedTest { collection in
      Sort.quickSort(&collection)
    }
  }

  func test_countingSort() {
    sharedTest { collection in
      Sort.countingSort(&collection)
    }
  }

  func test_integerSort() {
    sharedTest { collection in
      Sort.integerSort(&collection)
    }
  }

  func test_integerSort2() {
    struct T {
      let string: String
      let int: Int
    }

    var array = [
      T(string: "c", int: 3),
      T(string: "b", int: 2),
      T(string: "a", int: 1),
      T(string: "D", int: 4),
      T(string: "d", int: 4),
      T(string: "A", int: 1),
    ]

    Sort.integerSort(&array) { $0.int }

    XCTAssertEqual(array[0].int, 1)
    XCTAssertEqual(array[0].string, "a")

    XCTAssertEqual(array[1].int, 1)
    XCTAssertEqual(array[1].string, "A")

    XCTAssertEqual(array[2].int, 2)
    XCTAssertEqual(array[2].string, "b")

    XCTAssertEqual(array[3].int, 3)
    XCTAssertEqual(array[3].string, "c")

    XCTAssertEqual(array[4].int, 4)
    XCTAssertEqual(array[4].string, "D")

    XCTAssertEqual(array[5].int, 4)
    XCTAssertEqual(array[5].string, "d")
  }

}

extension SortTests {

  func sharedTest(sort: (inout [Int]) -> Void) {
    // Empty
    do {
      var collection: [Int] = []
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    // 1 element
    do {
      var collection: [Int] = [1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    // 2 elements
    do {
      var collection: [Int] = [1, 2]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [2, 1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    // 3 elements
    do {
      var collection: [Int] = [1, 2, 3]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [1, 3, 2]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [2, 1, 3]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [2, 3, 1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [3, 1, 2]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [3, 2, 1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    // 4 elements
    do {
      var collection: [Int] = [1, 2, 3, 4]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [4, 3, 2, 1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [4, 2, 1, 3]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    // 5 elements
    do {
      var collection: [Int] = [5, 4, 3, 2, 1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    // 6 elements
    do {
      var collection: [Int] = [6, 5, 4, 3, 2, 1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    do {
      var collection: [Int] = [6, 6, 4, 6, 2, 6]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

    // Negative numbers
    do {
      var collection: [Int] = [-1, -3, -9, 10, 2, -1]
      let sorted = collection.sorted()
      sort(&collection)
      XCTAssertEqual(collection, sorted)
    }

  }

}
