import Essentialis
import XCTest

final class MaxBinaryHeapTests: XCTestCase {

  func test_makeWithInit() {
    var heap = makeHeapWithInit()
    sharedTest(heap: &heap)
  }

  func test_makeWithInsert() {
    var heap = makeHeapWithInsert()
    sharedTest(heap: &heap)
  }

  func test_makeWithMerge() {
    var heap = makeHeapWithMerge()
    sharedTest(heap: &heap)
  }

  func test_firstIndex() {
    let heap = makeHeapWithInit()

    var index: Int?
    index = heap.firstIndex { key, value in key == 1 }
    XCTAssertEqual(heap[index!], "a")

    index = heap.firstIndex { key, value in key == 2 }
    XCTAssertEqual(heap[index!], "b")

    index = heap.firstIndex { key, value in key == 3 }
    XCTAssertEqual(heap[index!], "c")

    index = heap.firstIndex { key, value in key == 4 }
    XCTAssertEqual(heap[index!], "d")

    index = heap.firstIndex { key, value in key == 5 }
    XCTAssertEqual(heap[index!], "e")

    index = heap.firstIndex { key, value in key == -1 }
    XCTAssertNil(index)
  }

  func test_remove() {
    var heap = makeHeapWithInit()

    do {
      let index = heap.firstIndex { key, value in key == 1 }!
      let elem = heap.remove(at: index)
      XCTAssertEqual(elem, "a")
    }

    do {
      let index = heap.firstIndex { key, value in key == 5 }!
      let elem = heap.remove(at: index)
      XCTAssertEqual(elem, "e")
    }

    do {
      let index = heap.firstIndex { key, value in key == 2 }!
      let elem = heap.remove(at: index)
      XCTAssertEqual(elem, "b")
    }

    XCTAssertEqual(heap.count, 2)

    XCTAssertEqual(heap.peek, "d")
    XCTAssertEqual(heap.extract(), "d")
    XCTAssertEqual(heap.count, 1)

    XCTAssertEqual(heap.peek, "c")
    XCTAssertEqual(heap.extract(), "c")
    XCTAssertEqual(heap.count, 0)

    XCTAssertNil(heap.peek)
    XCTAssertEqual(heap.count, 0)
  }

  func test_changeKey() {
    var heap = makeHeapWithInit()
    let index = heap.firstIndex { key, value in key == 1 }!
    heap.changeKeyForElement(at: index, to: Int.max)

    XCTAssertEqual(heap.peek, "a")
    XCTAssertEqual(heap.extract(), "a")
    XCTAssertEqual(heap.count, 4)
  }

}

extension MaxBinaryHeapTests {

  func makeHeapWithInit() -> MaxBinaryHeap<Int, String> {
    let heap: MaxBinaryHeap = [
      (key: 5, elem: "e"),
      (key: 2, elem: "b"),
      (key: 1, elem: "a"),
      (key: 4, elem: "d"),
      (key: 3, elem: "c"),
    ]
    return heap
  }

  func makeHeapWithInsert() -> MaxBinaryHeap<Int, String> {
    var heap = MaxBinaryHeap<Int, String>()
    heap.insert(key: 5, element: "e")
    heap.insert(key: 2, element: "b")
    heap.insert(key: 1, element: "a")
    heap.insert(key: 4, element: "d")
    heap.insert(key: 3, element: "c")
    return heap
  }

  func makeHeapWithMerge() -> MaxBinaryHeap<Int, String> {
    var heap: MaxBinaryHeap = [
      (key: 5, elem: "e"),
      (key: 2, elem: "b"),
    ]

    let heap2: MaxBinaryHeap = [
      (key: 4, elem: "d"),
      (key: 3, elem: "c"),
    ]

    heap.merge(with: heap2)
    heap.insert(key: 1, element: "a")
    return heap
  }

  func sharedTest(heap: inout MaxBinaryHeap<Int, String>) {
    XCTAssertEqual(heap.count, 5)

    XCTAssertEqual(heap.peek, "e")
    XCTAssertEqual(heap.extract(), "e")
    XCTAssertEqual(heap.count, 4)

    XCTAssertEqual(heap.peek, "d")
    XCTAssertEqual(heap.extract(), "d")
    XCTAssertEqual(heap.count, 3)

    XCTAssertEqual(heap.peek, "c")
    XCTAssertEqual(heap.extract(), "c")
    XCTAssertEqual(heap.count, 2)

    XCTAssertEqual(heap.peek, "b")
    XCTAssertEqual(heap.extract(), "b")
    XCTAssertEqual(heap.count, 1)

    XCTAssertEqual(heap.peek, "a")
    XCTAssertEqual(heap.extract(), "a")
    XCTAssertEqual(heap.count, 0)

    XCTAssertNil(heap.peek)
    XCTAssertEqual(heap.count, 0)
  }

}
