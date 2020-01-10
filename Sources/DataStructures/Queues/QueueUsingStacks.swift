public struct QueueUsingStacks<Element> {

  private var stackEnqueue = StackUsingArray<Element>()
  private var stackDequeue = StackUsingArray<Element>()

  public init() {}

}

extension QueueUsingStacks {

  /// - Complexity: O(n)
  public mutating func enqueue(_ newElement: Element) {
    while let elem = stackDequeue.pop() {
      stackEnqueue.push(elem)
    }
    stackEnqueue.push(newElement)
  }

  /// - Complexity: O(n)
  @discardableResult
  public mutating func dequeue() -> Element? {
    while let elem = stackEnqueue.pop() {
      stackDequeue.push(elem)
    }
    return stackDequeue.pop()
  }

  /// - Complexity: O(1)
  public var isEmpty: Bool {
    stackEnqueue.isEmpty && stackDequeue.isEmpty
  }

}
