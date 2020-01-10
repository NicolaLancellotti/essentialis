public class BinarySearchTree<Key: Comparable> {

  private var root: Node? = nil

  public init() {}

  /// - Complexity: O(h)
  public func search(key: Key) -> Node? {
    root?.search(key: key)
  }

  /// - Complexity: O(h)
  public var min: Node? {
    root?.min
  }

  /// - Complexity: O(h)
  public var max: Node? {
    root?.max
  }

  /// - Complexity: O(h)
  public func insert(key: Key) {
    guard let root = root else {
      self.root = Node(parent: nil, key: key)
      return
    }

    var parent = root
    var optChild = key < parent.key ? parent.left : parent.right

    while let child = optChild, child.key != key {
      optChild = key < child.key ? child.left : child.right
      parent = child
    }

    let node = Node(parent: parent, key: key)
    if key < parent.key {
      parent.left = node
    } else {
      parent.right = node
    }
  }

  /// - Complexity: O(h)
  public func delete(key: Key) {
    guard let toDelete = search(key: key) else { return }

    func transplant(toDelete: Node, new: Node?) {
      guard let parent = toDelete.parent else {
        root = new
        new?.parent = nil
        return
      }

      let isleftChild = toDelete.parent?.left == toDelete
      switch isleftChild {
      case true: parent.left = new
      case false: parent.right = new
      }
      new?.parent = parent
    }

    switch (toDelete.left, toDelete.right) {
    case (nil, nil):
      transplant(toDelete: toDelete, new: nil)
    case (.some(let left), nil):
      transplant(toDelete: toDelete, new: left)
    case (nil, .some(let right)):
      transplant(toDelete: toDelete, new: right)
    case (.some(let left), .some(let right)):
      let successor = toDelete.successor!

      if right != successor {
        transplant(toDelete: successor, new: successor.right)
        successor.right = right
        right.parent = successor
      }

      transplant(toDelete: toDelete, new: successor)
      successor.left = left
      left.parent = successor
    }
  }

  public func inorderVisit() -> [Node] {
    var array = [Node]()
    root?.inorderVisit(&array)
    return array
  }

}

extension BinarySearchTree {

  public class Node: Equatable {
    fileprivate var parent: Node?
    fileprivate var left: Node? = nil
    fileprivate var right: Node? = nil
    public let key: Key

    fileprivate init(parent: Node?, key: Key) {
      self.parent = parent
      self.key = key
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
      ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    fileprivate func search(key: Key) -> Node? {
      var optNode: Node? = self
      while let node = optNode, node.key != key {
        optNode = key < node.key ? node.left : node.right
      }
      return optNode
    }

    fileprivate var min: Node {
      var node: Node = self
      while let child = node.left {
        node = child
      }
      return node
    }

    fileprivate var max: Node? {
      var node: Node = self
      while let child = node.right {
        node = child
      }
      return node
    }

    fileprivate var successor: Node? {
      if let right = self.right {
        return right.min
      }

      var (optParent, child) = (self.parent, self)
      while let parent = optParent, parent.right == child {
        optParent = parent.parent
        child = parent
      }
      return optParent
    }

    func inorderVisit(_ array: inout [Node]) {
      left?.inorderVisit(&array)
      array.append(self)
      right?.inorderVisit(&array)
    }
  }

}
