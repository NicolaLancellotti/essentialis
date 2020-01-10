import Essentialis
import XCTest

final class TreeUsingParentDictionaryTests: XCTestCase {

  func test_addChild_getParent() {
    var tree = TreeUsingParentDictionary<String>()
    tree.addChild("B", to: "A")
    tree.addChild("C", to: "A")
    tree.addChild("D", to: "B")

    XCTAssertEqual(tree.parent(of: "A"), nil)
    XCTAssertEqual(tree.parent(of: "B"), "A")
    XCTAssertEqual(tree.parent(of: "C"), "A")
    XCTAssertEqual(tree.parent(of: "D"), "B")
  }
}
