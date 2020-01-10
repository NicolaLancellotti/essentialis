import Essentialis
import XCTest

final class SinglyLinkedListTests: XCTestCase {

  func test_copy() {
    let list = SinglyLinkedList<Int>([1, 2, 3])
    var list1 = list
    list1[0] = -1

    XCTAssertEqual(list[0], 1)
    XCTAssertEqual(list[1], 2)
    XCTAssertEqual(list[2], 3)

    XCTAssertEqual(list1[0], -1)
    XCTAssertEqual(list1[1], 2)
    XCTAssertEqual(list1[2], 3)
  }

  func test_collection() {
    var list = SinglyLinkedList<Int>()
    XCTAssertTrue(list.isEmpty)
    XCTAssertEqual(list.count, 0)

    let elements = [1, 2]

    list.append(elements[0])
    XCTAssertEqual(list.count, 1)
    XCTAssertFalse(list.isEmpty)

    list.append(elements[1])
    XCTAssertEqual(list.count, 2)
    XCTAssertFalse(list.isEmpty)

    var index = list.startIndex
    XCTAssertEqual(list[index], elements[0])

    list.formIndex(after: &index)
    XCTAssertEqual(list[index], elements[1])

    list.formIndex(after: &index)
    XCTAssertEqual(index, list.endIndex)

    XCTAssertEqual(list.reduce(0, +), elements.reduce(0, +))

    XCTAssertEqual(list.first, 1)

    XCTAssertTrue(list.contains(2))
    XCTAssertFalse(list.contains(3))

    XCTAssertEqual(
      list.firstIndex(of: 2),
      list.index(after: list.startIndex))
  }

  func test_mutableCollection() {
    var list = SinglyLinkedList<Int>()

    list.append(1)
    list.append(2)

    var index = list.startIndex
    list[index] = 10

    index = list.index(after: list.startIndex)
    list[index] = 20

    index = list.startIndex
    XCTAssertEqual(list[index], 10)

    list.formIndex(after: &index)
    XCTAssertEqual(list[index], 20)
  }

  func test_otherMethods() {
    var list = SinglyLinkedList<Int>([1, 2, 3])

    // last
    XCTAssertEqual(list.last, 3)

    // subscript
    list[0] *= -1
    list[1] *= -1
    list[2] *= -1

    XCTAssertEqual(list[0], -1)
    XCTAssertEqual(list[1], -2)
    XCTAssertEqual(list[2], -3)

    // Reverse
    do {
      var list = SinglyLinkedList<Int>([1, 2, 3])
      list.reverse()
      XCTAssertEqual(list[0], 3)
      XCTAssertEqual(list[1], 2)
      XCTAssertEqual(list[2], 1)
    }
  }

  // MARK: Range Replaceable Collection

  func test_rangeReplaceableCollection_init() {
    let list = SinglyLinkedList<Int>([1, 2, 3, 4])
    XCTAssertEqual(list[0], 1)
    XCTAssertEqual(list[1], 2)
    XCTAssertEqual(list[2], 3)
    XCTAssertEqual(list[3], 4)
  }

  func test_rangeReplaceableCollection_append() {
    var list = SinglyLinkedList<Int>()
    list.append(1)
    list.append(2)
    list.append(contentsOf: [3, 4])

    XCTAssertEqual(list[0], 1)
    XCTAssertEqual(list[1], 2)
    XCTAssertEqual(list[2], 3)
    XCTAssertEqual(list[3], 4)
  }

  func test_rangeReplaceableCollection_remove() {
    do {
      var list = SinglyLinkedList<Int>([1, 2, 3, 4])

      // remove in the middle
      XCTAssertEqual(list.remove(at: list.index(after: list.startIndex)), 2)
      XCTAssertEqual(list[0], 1)
      XCTAssertEqual(list[1], 3)
      XCTAssertEqual(list[2], 4)
      XCTAssertEqual(list.count, 3)

      // remove first
      XCTAssertEqual(list.remove(at: list.startIndex), 1)
      XCTAssertEqual(list[0], 3)
      XCTAssertEqual(list[1], 4)
      XCTAssertEqual(list.count, 2)

      // remove last
      XCTAssertEqual(list.remove(at: list.index(after: list.startIndex)), 4)
      XCTAssertEqual(list[0], 3)
      XCTAssertEqual(list.count, 1)

      // remove the only one
      XCTAssertEqual(list.remove(at: list.startIndex), 3)
      XCTAssertEqual(list.count, 0)
    }

    do {
      var list = SinglyLinkedList<Int>([1, 2, 3, 4])

      XCTAssertEqual(list.removeFirst(), 1)
      XCTAssertEqual(list[0], 2)
      XCTAssertEqual(list[1], 3)
      XCTAssertEqual(list[2], 4)
      XCTAssertEqual(list.count, 3)

      list.removeFirst(2)
      XCTAssertEqual(list[0], 4)
      XCTAssertEqual(list.count, 1)
    }

    do {
      var list = SinglyLinkedList<Int>([1, 2, 3, 4])
      list.removeSubrange(list.index(after: list.startIndex)..<list.endIndex)
      XCTAssertEqual(list[0], 1)
      XCTAssertEqual(list.count, 1)
    }
  }

  func test_equatable() {
    do {
      let list = SinglyLinkedList<Int>([1, 2, 3, 4])
      XCTAssertEqual(list, list)
    }

    do {
      let list = SinglyLinkedList<Int>([1, 2, 3, 4])
      var list1 = list
      list1[0] = -1
      XCTAssertNotEqual(list, list1)
    }
  }

  func test_comparable() {
    do {
      let list = SinglyLinkedList<Int>([1, 2, 3, 4])
      XCTAssertTrue(list <= list)
    }

    do {
      let list1 = SinglyLinkedList<Int>([1, 2, 3])
      let list2 = SinglyLinkedList<Int>([3, 2, 3])
      XCTAssertTrue(list1 <= list2)
      XCTAssertTrue(list1 < list2)
    }
  }

}
