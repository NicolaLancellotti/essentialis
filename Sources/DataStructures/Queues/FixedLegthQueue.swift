public struct FixedLengthQueue<Element> {

  private var array: FixedLengthArray<Element?>
  private var headIndex = 0
  private var tailIndex = 0
  private var count = 0

  public init(count: Int) {
    precondition(count > 0, "count must be greater than 0")
    array = .init(repeating: nil, count: count)
  }

  public enum FixedLengthQueueError: Error {
    case full
  }

  /// - Complexity: Θ(1)
  public mutating func enqueue(_ newElement: Element) throws {
    if isFull {
      throw FixedLengthQueueError.full
    }
    count += 1
    array[tailIndex] = newElement
    tailIndex = nextIndex(tailIndex)
  }

  /// - Complexity: Θ(1)
  @discardableResult
  public mutating func dequeue() -> Element? {
    if isEmpty {
      return nil
    }
    count -= 1
    defer {
      headIndex = nextIndex(headIndex)
    }
    return array[headIndex]!
  }

  /// - Complexity: Θ(1)
  public var isEmpty: Bool {
    headIndex == tailIndex && count == 0
  }

  /// - Complexity: Θ(1)
  public var isFull: Bool {
    headIndex == tailIndex && count != 0
  }

  private func nextIndex(_ index: Int) -> Int {
    (index + 1) % array.count
  }

}
