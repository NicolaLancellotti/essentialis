import Essentialis
import XCTest

final class MathsTests: XCTestCase {

  func test_power_BinaryInteger() {
    let values: [(base: Int8, esp: UInt, result: Int8)] = [
      (2, 0, 1),
      (2, 1, 2),
      (2, 2, 4),
      (2, 3, 8),
    ]

    for (base, esp, result) in values {
      XCTAssertEqual(Maths.power(base: base, exp: esp), result)
    }
  }

  func test_power_FloatingPoint() {
    do {
      let values: [(base: Double, esp: Int, result: Double)] = [
        (2.0, 0, 1),
        (2.0, 1, 2),
        (2.0, -1, 0.5),
        (2.0, 2, 4),
        (2.0, -2, 0.25),
        (2.0, 3, 8),
        (2.0, -3, 0.125),
      ]

      for (base, esp, result) in values {
        XCTAssertEqual(Maths.power(base: base, exp: esp), result)
      }
    }

    do {
      let accuracy = 0.000000001
      let values: [(base: Double, esp: Int, result: Double)] = [
        (2.1, 0, 1),
        (2.1, 1, 2.1),
        (2.1, -1, 0.476190476),
        (2.1, 2, 4.41),
        (2.1, -2, 0.22675737),
        (2.1, 3, 9.261),
        (2.1, -3, 0.1079797),
      ]

      for (base, esp, result) in values {
        XCTAssertEqual(Maths.power(base: base, exp: esp), result, accuracy: accuracy)
      }
    }
  }

  func test_greatestCommonDivisor() {
    XCTAssertEqual(Maths.greatestCommonDivisor(2, 3), 1)
    XCTAssertEqual(Maths.greatestCommonDivisor(2, 6), 2)
    XCTAssertEqual(Maths.greatestCommonDivisor(6, 2), 2)
  }

  func test_leastCommonMultiple() {
    XCTAssertEqual(Maths.leastCommonMultiple(2, 3), 6)
    XCTAssertEqual(Maths.leastCommonMultiple(2, 6), 6)
    XCTAssertEqual(Maths.leastCommonMultiple(6, 2), 6)
  }

}
