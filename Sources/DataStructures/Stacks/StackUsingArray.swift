public struct StackUsingArray<Element> {

  private var array = [Element]()

  public init() {}

}

extension StackUsingArray {

  /// - Complexity: O(1)
  public mutating func push(_ newElement: Element) {
    array.append(newElement)
  }

  /// - Complexity: O(1)
  @discardableResult
  public mutating func pop() -> Element? {
    array.popLast()
  }

  /// - Complexity: O(1)
  public var isEmpty: Bool {
    array.isEmpty
  }

}

extension StackUsingArray: Equatable where Element: Equatable {}

extension StackUsingArray: Hashable where Element: Hashable {}
