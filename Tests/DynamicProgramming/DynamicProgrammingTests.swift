import Essentialis
import XCTest

final class DynamicProgrammingTests: XCTestCase {
  
  func test_cutRod() {
    let prices = [0, 1, 5, 8, 9, 10, 17, 17, 20, 24, 30]
    let (price, cuts) = DP.cutRod(prices: prices, length: 4)
    XCTAssertEqual(price, 10)
    XCTAssertEqual(cuts, [2, 2])
  }
  
}
