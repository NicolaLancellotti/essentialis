public struct TreeUsingParentDictionary<Node: Hashable> {

  private var dictionary = [Node: Node]()

  public init() {}

  mutating public func addChild(_ child: Node, to parent: Node) {
    dictionary[child] = parent
  }

  public func parent(of child: Node) -> Node? {
    dictionary[child]
  }

}
