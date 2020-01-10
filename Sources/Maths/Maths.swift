import Foundation

public enum Maths {

  /// Compute the power: *base^exp* with the repeated squares method
  /// - Complexity: O(log(exp))
  public static func power<T: BinaryInteger>(base: T, exp: some UnsignedInteger) -> T {
    switch exp {
    case 0:
      return 1
    default:
      var value = power(base: base, exp: exp / 2)
      value *= value
      return exp.isMultiple(of: 2) ? value : value * base
    }
  }

  /// Compute the power: *base^exp* with the repeated squares method
  /// - Complexity: O(log(exp))
  public static func power<T: FloatingPoint>(base: T, exp: some BinaryInteger) -> T {
    switch exp {
    case 0:
      return 1
    case let exp where exp < 0:
      return 1 / power(base: base, exp: exp * exp.signum())
    default:
      var value = power(base: base, exp: exp / 2)
      value *= value
      return exp.isMultiple(of: 2) ? value : value * base
    }
  }

  public static func greatestCommonDivisor(_ x: Int, _ y: Int) -> Int {
    var (x, y) = (abs(x), abs(y))
    (x, y) = (max(x, y), min(x, y))
    while y != 0 {
      (x, y) = (y, x % y)
    }
    return x
  }

  public static func leastCommonMultiple(_ x: Int, _ y: Int) -> Int {
    x * y / Maths.greatestCommonDivisor(x, y)
  }

  public static func solveQuadraticEquation(a: Double, b: Double, c: Double) -> (
    min: Double, max: Double
  ) {
    let sqrtDelta = sqrt(pow(b, 2) - 4 * a * c)
    let x1 = (-b - sqrtDelta) / (2 * a)
    let x2 = (-b + sqrtDelta) / (2 * a)
    return (min(x1, x2), max(x1, x2))
  }

}
