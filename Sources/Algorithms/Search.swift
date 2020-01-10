extension RandomAccessCollection where Element: Comparable {

  /// - Complexity: O(log(n))
  public func binarySearch(_ element: Element) -> Index? {
    var (left, right) = (startIndex, index(before: endIndex))

    while left <= right {
      let middle = index(left, offsetBy: distance(from: left, to: right) / 2)
      switch self[middle] {
      case let middleElem where element < middleElem:
        right = self.index(before: middle)
      case let middleElem where element > middleElem:
        left = self.index(after: middle)
      default:
        return middle
      }
    }
    return nil
  }
}
