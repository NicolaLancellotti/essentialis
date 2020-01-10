public struct FixedLengthArray<Element> {

  private var buffer: FixedLengthArrayRef

  public init(repeating repeatedValue: Element, count: Int) {
    let sequence = repeatElement(repeatedValue, count: count)
    buffer = FixedLengthArrayRef(sequence: sequence, count: count)
  }

}

extension FixedLengthArray: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: Element...) {
    buffer = FixedLengthArrayRef(sequence: elements, count: elements.count)
  }

}

extension FixedLengthArray: Collection, MutableCollection {

  /// - Complexity: O(1)
  public var startIndex: Int {
    buffer.buffer.startIndex
  }

  /// - Complexity: O(1)
  public var endIndex: Int {
    buffer.buffer.endIndex
  }

  /// - Complexity: O(1)
  public func index(after i: Int) -> Int {
    buffer.buffer.index(after: i)
  }

  /// - Complexity: O(1)
  public subscript(position: Int) -> Element {
    get {
      buffer.buffer[position]
    }
    set {
      if !isKnownUniquelyReferenced(&buffer) {
        buffer = buffer.copy()
      }
      buffer.buffer[position] = newValue
    }
  }

}

extension FixedLengthArray: BidirectionalCollection {

  /// - Complexity: O(1)
  public func index(before i: Int) -> Int {
    buffer.buffer.index(before: i)
  }

}

extension FixedLengthArray: RandomAccessCollection {}

extension FixedLengthArray: Equatable where Element: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    zip(lhs.buffer.buffer, rhs.buffer.buffer).first(where: !=) == nil
  }

}

extension FixedLengthArray: Hashable where Element: Hashable {

  public func hash(into hasher: inout Hasher) {
    for elem in self.buffer.buffer {
      hasher.combine(elem)
    }
  }

}

extension FixedLengthArray: Comparable where Element: Comparable {

  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.buffer.buffer.lexicographicallyPrecedes(rhs.buffer.buffer)
  }

}

extension FixedLengthArray {

  fileprivate final class FixedLengthArrayRef {

    let buffer: UnsafeMutableBufferPointer<Element>

    init(sequence: some Sequence<Element>, count: Int) {
      buffer = UnsafeMutableBufferPointer(
        start: .allocate(capacity: count),
        count: count)
      let (_, index) = buffer.initialize(from: sequence)
      assert(index == count)
    }

    func copy() -> FixedLengthArrayRef {
      FixedLengthArrayRef(sequence: buffer, count: buffer.count)
    }

    deinit {
      buffer.baseAddress?.deinitialize(count: buffer.count)
      buffer.deallocate()
    }
  }

}
