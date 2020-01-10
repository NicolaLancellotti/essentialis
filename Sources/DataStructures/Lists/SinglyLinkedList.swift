public struct SinglyLinkedList<Element> {

  private var buffer = SinglyLinkedListRef<Element>()

  public init() {}

}

extension SinglyLinkedList {

  public subscript(index: Int) -> Element {
    get {
      self[self.index(startIndex, offsetBy: index)]
    }
    set {
      _testUniquelyReferenced()
      self[self.index(startIndex, offsetBy: index)] = newValue
    }
  }

  /// - Complexity: O(1)
  public var last: Element? {
    buffer.tail?.pointee.info
  }

  /// - Complexity: O(n)
  mutating public func reverse() {
    _testUniquelyReferenced()
    buffer.reverse()
  }

}

// MARK: Private

extension SinglyLinkedList {

  private mutating func _testUniquelyReferenced() {
    if !isKnownUniquelyReferenced(&buffer) {
      self = SinglyLinkedList(self)
    }
  }

}

// MARK: Collection Conformance

extension SinglyLinkedList {

  public struct Index: Comparable {

    fileprivate var node: SinglyLinkedListRef<Element>.NodePointer?
    fileprivate var index: Int

    public static func < (lhs: Index, rhs: Index) -> Bool {
      lhs.index < rhs.index
    }

  }
}

extension SinglyLinkedList: Collection, MutableCollection {

  public var startIndex: Index {
    buffer.isEmpty ? endIndex : Index(node: buffer.head, index: 0)
  }

  public var endIndex: Index {
    Index(node: nil, index: Int.max)
  }

  public func index(after i: Index) -> Index {
    let next = i.node?.pointee.next
    return next == nil ? endIndex : Index(node: next, index: i.index + 1)
  }

  public subscript(index: Index) -> Element {
    get {
      guard let node = index.node else {
        fatalError("Index out of range")
      }
      return node.pointee.info
    }
    set {
      guard let node = index.node else {
        fatalError("Index out of range")
      }
      _testUniquelyReferenced()
      node.pointee.info = newValue
    }
  }

}

extension SinglyLinkedList: RangeReplaceableCollection {

  public mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C)
  where C: Collection, R: RangeExpression, Element == C.Element, Index == R.Bound {

    _testUniquelyReferenced()
    let range = subrange.relative(to: self)

    let lowerBoundIndex = range.lowerBound.index
    var previous = isEmpty || lowerBoundIndex == 0 ? nil : buffer.node(at: lowerBoundIndex - 1)

    var index = range.lowerBound
    while index < range.upperBound {
      self.formIndex(after: &index)
      buffer.remove(after: previous)
    }

    for elem in newElements {
      previous = buffer.insert(elem, after: previous)
    }
  }

  public mutating func append(_ newElement: Element) {
    _testUniquelyReferenced()
    buffer.insert(newElement, after: buffer.tail)
  }

}

extension SinglyLinkedList: Equatable where Element: Equatable {

  public static func == (lhs: Self, rhs: Self) -> Bool {
    guard lhs.count == rhs.count else { return false }
    return zip(lhs, rhs).first(where: !=) == nil
  }
}

extension SinglyLinkedList: Comparable where Element: Comparable {

  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.lexicographicallyPrecedes(rhs)
  }

}

extension SinglyLinkedList: CustomDebugStringConvertible where Element: CustomStringConvertible {
  public var debugDescription: String {
    var s = "["
    for elem in self {
      s += "\(elem),"
    }
    s += "]"
    return s
  }
}

// MARK: SinglyLinkedListRef

private class SinglyLinkedListRef<Element> {

  typealias NodePointer = UnsafeMutablePointer<Node>

  struct Node {
    var info: Element
    var next: NodePointer?

    static func make(info: Element, next: NodePointer?) -> NodePointer {
      let node = NodePointer.allocate(capacity: 1)
      node.initialize(to: Node(info: info, next: next))
      return node
    }

    static func deinitializeAndDeallocate(_ node: NodePointer) {
      node.deinitialize(count: 1)
      node.deallocate()
    }

  }

  var head: NodePointer? = nil
  var tail: NodePointer? = nil

  var isEmpty: Bool {
    head == nil
  }

  @discardableResult
  func insert(_ newElement: Element, after previous: NodePointer?) -> NodePointer {
    switch previous {
    case .none:
      let newNode = Node.make(info: newElement, next: head)
      if self.isEmpty {
        tail = newNode
      }
      head = newNode
      return newNode
    case .some(let previous):
      let newNode = Node.make(info: newElement, next: previous.pointee.next)
      previous.pointee.next = newNode
      if previous == tail {
        tail = newNode
      }
      return newNode
    }
  }

  func remove(after previous: NodePointer?) {
    switch previous {
    case .none:
      let toRemove = self.head!
      self.head = toRemove.pointee.next
      if isEmpty {
        self.tail = nil
      }
      Node.deinitializeAndDeallocate(toRemove)
    case .some(let previous):
      let toRemove = previous.pointee.next!
      if toRemove == self.tail {
        self.tail = previous
      }
      previous.pointee.next = previous.pointee.next?.pointee.next
      Node.deinitializeAndDeallocate(toRemove)
    }
  }

  func reverse() {
    var newHead: NodePointer? = nil
    var current = self.head
    while let node = current {
      current = node.pointee.next
      node.pointee.next = newHead
      newHead = node
    }
    self.head = newHead
  }

  func node(at index: Int) -> NodePointer? {
    var iter = sequence(first: self.head) { $0?.pointee.next }
      .dropFirst(index).makeIterator()
    return iter.next()!
  }

}
