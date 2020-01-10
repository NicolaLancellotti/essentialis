public struct QueueUsingList<Element> {

  private var list = SinglyLinkedList<Element>()

  public init() {}

}

extension QueueUsingList {

  /// - Complexity: O(1)
  public mutating func enqueue(_ newElement: Element) {
    list.append(newElement)
  }

  /// - Complexity: O(1)
  @discardableResult
  public mutating func dequeue() -> Element? {
    list.isEmpty ? nil : list.removeFirst()
  }

  /// - Complexity: O(1)
  public var isEmpty: Bool {
    list.isEmpty
  }

}
