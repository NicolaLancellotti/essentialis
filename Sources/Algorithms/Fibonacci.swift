public enum Fibonacci {

  /// - Complexity: O(n)
  public static func fibIterative(_ n: Int) -> Int {
    precondition(n > 0, "n must be greater than zero")
    var previous = 1
    var current = 1
    for _ in stride(from: 3, through: n, by: 1) {
      (previous, current) = (current, previous + current)
    }
    return current
  }

  /// - Complexity: O(log(n))
  public static func fibMatrix(_ n: Int) -> Int {
    precondition(n > 0, "n must be greater than zero")
    return Tensor(dimensions: [2, 2], values: [1, 1, 1, 0]).power2D(n - 1)[0, 0]
  }

}
