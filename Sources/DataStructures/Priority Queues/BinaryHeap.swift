// MARK: - MinBinaryHeap

public struct MinBinaryHeapType<Key: Comparable>: BinaryHeapTypeProtocol {
  public static var op: (Key, Key) -> Bool { { $0 < $1 } }
}

public typealias MinBinaryHeap<Key: Comparable, Element> = BinaryHeap<
  Key, Element, MinBinaryHeapType<Key>
>

// MARK: - MaxBinaryHeap

public struct MaxBinaryHeapType<Key: Comparable>: BinaryHeapTypeProtocol {
  public static var op: (Key, Key) -> Bool { { $0 > $1 } }
}

public typealias MaxBinaryHeap<Key: Comparable, Element> = BinaryHeap<
  Key, Element, MaxBinaryHeapType<Key>
>

// MARK: - BinaryHeap

public protocol BinaryHeapTypeProtocol<Key> {
  associatedtype Key
  static var op: (Key, Key) -> Bool { get }
}

public struct BinaryHeap<Key, Element, HeapType: BinaryHeapTypeProtocol<Key>>
where Key: Comparable {

  private var buffer: [(key: Key, elem: Element)]
}

extension BinaryHeap: ExpressibleByArrayLiteral {

  /// - Complexity: O(n)
  public init(arrayLiteral elements: (Key, Element)...) {
    self.buffer = elements
    build()
  }

}

extension BinaryHeap {

  /// - Complexity: O(1)
  public var count: Int {
    buffer.count
  }

  /// - Complexity: O(1)
  public var peek: Element? {
    buffer.first?.elem
  }

  /// - Complexity: O(lon(n))
  public mutating func extract() -> Element? {
    buffer.isEmpty ? nil : remove(at: 0)
  }

  /// - Complexity: O(lon(n))
  public mutating func insert(key: Key, element: Element) {
    buffer.append((key, element))
    moveUp(index: buffer.count - 1)
  }

  public init(elements: some Sequence<(Key, Element)>) {
    self.buffer = Array(elements)
    build()
  }

}

extension BinaryHeap {

  /// - Complexity: O(n)
  public func firstIndex(where predicate: (_ key: Key, _ elem: Element) throws -> Bool) rethrows
    -> Int?
  {
    try buffer.firstIndex(where: predicate)
  }

  /// - Complexity: O(1)
  public subscript(index: Int) -> Element {
    buffer[index].elem
  }

  /// - Complexity: O(lon(n))
  mutating public func remove(at index: Int) -> Element {
    precondition(index >= 0 && index < buffer.count, "Index out of range")

    if index == buffer.count - 1 {
      return buffer.popLast()!.elem
    }

    let value = buffer[index].elem
    buffer[index] = buffer.popLast()!
    moveUp(index: index)
    moveDown(index: index)
    return value
  }

  /// - Complexity: O(lon(n))
  public mutating func changeKeyForElement(at index: Int, to key: Key) {
    precondition(index >= 0 && index < buffer.count, "Index out of range")

    let oldKey = buffer[index].key
    buffer[index].key = key

    HeapType.op(oldKey, key) ? moveDown(index: index) : moveUp(index: index)
  }

}

extension BinaryHeap {

  /// - Complexity: O(n + m) where n = self.count, m = minHeap.count
  public mutating func merge(with minHeap: BinaryHeap) {
    buffer.append(contentsOf: minHeap.buffer)
    build()
  }

}

extension BinaryHeap {

  /// - Complexity: O(n)
  private mutating func build() {
    for index in stride(from: buffer.count / 2 - 1, through: 0, by: -1) {
      moveDown(index: index)
    }
  }

  /// - Complexity: O(log(n))
  private mutating func moveDown(index: Int) {
    var index = index
    while true {
      var priorityIndex = index

      func updatePriorityIndex(index: Int?) {
        if let index, HeapType.op(buffer[index].key, buffer[priorityIndex].key) {
          priorityIndex = index
        }
      }

      updatePriorityIndex(index: leftChild(of: index))
      updatePriorityIndex(index: rightChild(of: index))

      if priorityIndex == index {
        return
      }

      buffer.swapAt(index, priorityIndex)
      index = priorityIndex
    }
  }

  /// - Complexity: O(log(n))
  private mutating func moveUp(index: Int) {
    var current = index
    while let p = parent(of: current), HeapType.op(buffer[current].key, buffer[p].key) {
      buffer.swapAt(p, current)
      current = p
    }
  }

  private func leftChild(of index: Int) -> Int? {
    let index = index << 1 + 1  // index * 2 + 1
    guard index < buffer.count else { return nil }
    return index
  }

  private func rightChild(of index: Int) -> Int? {
    let index = index << 1 + 2  // index * 2 + 2
    guard index < buffer.count else { return nil }
    return index
  }

  private func parent(of index: Int) -> Int? {
    let index = index >> 1  // index / 2
    guard index >= 0 else { return nil }
    return index
  }

}
