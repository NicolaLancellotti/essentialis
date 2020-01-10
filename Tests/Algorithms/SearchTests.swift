import Essentialis
import XCTest

final class SearchTests: XCTestCase {

  func test_binarySearch_empty() {
    XCTAssertNil([].binarySearch(-1))
  }

  func test_binarySearch() {
    let collection = ["a", "b", "c", "d"]

    XCTAssertNil(collection.binarySearch("z"))
    XCTAssertNil(collection.binarySearch("y"))

    do {
      let elem = "a"
      let index = collection.binarySearch(elem)
      XCTAssertEqual(index, 0)
    }

    do {
      let elem = "b"
      let index = collection.binarySearch(elem)
      XCTAssertEqual(index, 1)
    }

    do {
      let elem = "c"
      let index = collection.binarySearch(elem)
      XCTAssertEqual(index, 2)
    }

    do {
      let elem = "d"
      let index = collection.binarySearch(elem)
      XCTAssertEqual(index, 3)
    }
  }

}
