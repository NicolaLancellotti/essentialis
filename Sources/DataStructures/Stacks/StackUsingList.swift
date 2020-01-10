public struct StackUsingList<Element> {

  private var list = SinglyLinkedList<Element>()

  public init() {}

}

extension StackUsingList {

  /// - Complexity: O(1)
  public mutating func push(_ newElement: Element) {
    list.insert(newElement, at: list.startIndex)
  }

  /// - Complexity: O(1)
  @discardableResult
  public mutating func pop() -> Element? {
    list.isEmpty ? nil : list.removeFirst()
  }

  /// - Complexity: O(1)
  public var isEmpty: Bool {
    list.isEmpty
  }

}
