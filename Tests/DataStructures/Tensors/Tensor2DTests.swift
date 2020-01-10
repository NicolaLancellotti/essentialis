import Essentialis
import XCTest

final class Tensor2DTests: XCTestCase {

  func test_is2D() {
    XCTAssertFalse(Tensor(dimensions: [2], repeating: 1).is2DSquare)
    XCTAssertTrue(Tensor(dimensions: [2, 2], repeating: 1).is2D)
  }

  func test_isSquare() {
    XCTAssertTrue(Tensor(dimensions: [2, 2], repeating: 1).is2DSquare)
    XCTAssertFalse(Tensor(dimensions: [2, 3], repeating: 1).is2DSquare)
    XCTAssertFalse(Tensor(dimensions: [2, 3], repeating: 1).is2DSquare)
  }

  func test_make2DIdentity() {
    let tensor = Tensor<Int>.make2DIdentity(2)
    XCTAssertEqual(tensor, Tensor(dimensions: [2, 2], values: [1, 0, 0, 1]))
  }

  func test_multiply2D() {
    let tensor1 = Tensor<Int>(dimensions: [2, 2], values: [1, 2, 3, 4])
    let tensorResult1 = Tensor<Int>(dimensions: [2, 2], values: [7, 10, 15, 22])
    XCTAssertEqual(Tensor.multiply2D(tensor1, tensor1), tensorResult1)

    let tensor2 = Tensor<Int>(dimensions: [2, 3], values: [1, 2, 3, 4, 5, 6])
    let tensorResult2 = Tensor<Int>(dimensions: [2, 3], values: [9, 12, 15, 19, 26, 33])
    XCTAssertEqual(Tensor.multiply2D(tensor1, tensor2), tensorResult2)
  }

  func test_power2D() {
    let tensor = Tensor(dimensions: [2, 2], values: [1, 2, 3, 4])
    XCTAssertEqual(tensor.power2D(0), Tensor.make2DIdentity(2))
    XCTAssertEqual(tensor.power2D(1), tensor)
    XCTAssertEqual(tensor.power2D(2), Tensor.multiply2D(tensor, tensor))
    XCTAssertEqual(tensor.power2D(3), Tensor.multiply2D(Tensor.multiply2D(tensor, tensor), tensor))
  }

}
