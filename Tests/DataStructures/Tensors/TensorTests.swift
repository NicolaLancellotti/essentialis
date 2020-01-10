import Essentialis
import XCTest

final class TensorTests: XCTestCase {

  func test_subscript() {
    let tensor = Tensor(dimensions: [2, 1], values: [1, 2])
    XCTAssertEqual(tensor[0, 0], 1)
    XCTAssertEqual(tensor[1, 0], 2)
  }

  func test_dim() {
    let tensor = Tensor(dimensions: [2, 3], repeating: 0)
    XCTAssertEqual(tensor.dim(0), 2)
    XCTAssertEqual(tensor.dim(1), 3)
  }

  func test_count() {
    XCTAssertEqual(Tensor(dimensions: [], values: []).count, 0)
    XCTAssertEqual(Tensor(dimensions: [1], repeating: 0).count, 1)
    XCTAssertEqual(Tensor(dimensions: [2, 3], repeating: 0).count, 6)
  }

}
