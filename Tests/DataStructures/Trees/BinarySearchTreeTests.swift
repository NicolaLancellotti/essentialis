import Essentialis
import XCTest

final class BinarySearchTreeTests: XCTestCase {

  func makeTree(keys: [Int]) -> BinarySearchTree<Int> {
    let tree = BinarySearchTree<Int>()
    for key in keys {
      tree.insert(key: key)
    }
    return tree
  }

  func test_search() {
    do {
      let tree = makeTree(keys: [])
      XCTAssertNil(tree.search(key: 10))
    }

    do {
      let keys = [10, 5, 1, 6, 15, 14, 16]
      let tree = makeTree(keys: keys)

      for key in keys {
        XCTAssertEqual(tree.search(key: key)?.key, key)
      }
    }
  }

  func test_min_max() {
    let keys = [10, 5, 1, 6, 15, 14, 16]
    let tree = makeTree(keys: keys)
    XCTAssertEqual(tree.min?.key, 1)
    XCTAssertEqual(tree.max?.key, 16)
  }

  func test_deleteRoot() {
    do {  // Delete root with no children
      let keys = [10]
      let tree = makeTree(keys: keys)
      tree.delete(key: 10)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [])
    }

    do {  // Delete root with left child
      let keys = [10, 5]
      let tree = makeTree(keys: keys)
      tree.delete(key: 10)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [5])
    }

    do {  // Delete root with right child
      let keys = [10, 15]
      let tree = makeTree(keys: keys)
      tree.delete(key: 10)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [15])
    }

    do {  // Delete root with children
      let keys = [10, 5, 15]
      let tree = makeTree(keys: keys)
      tree.delete(key: 10)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [5, 15])
    }
  }

  func test_deleteInternalNode() {
    do {  // Delete node with no children
      let keys = [10, 5]
      let tree = makeTree(keys: keys)
      tree.delete(key: 5)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [10])
    }

    do {  // Delete node with left child
      let keys = [10, 5, 1]
      let tree = makeTree(keys: keys)
      tree.delete(key: 5)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [1, 10])
    }

    do {  // Delete node with right child
      let keys = [10, 5, 6]
      let tree = makeTree(keys: keys)
      tree.delete(key: 5)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [6, 10])
    }

    do {  // Delete node with children - - successor is the right child
      let keys = [10, 5, 1, 6]
      let tree = makeTree(keys: keys)
      tree.delete(key: 5)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [1, 6, 10])
    }

    do {  // Delete node with children - successor is not the right child
      let keys = [10, 5, 1, 7, 6]
      let tree = makeTree(keys: keys)
      tree.delete(key: 5)
      XCTAssertEqual(tree.inorderVisit().map(\.key), [1, 6, 7, 10])
    }
  }

}
