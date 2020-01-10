public final class GraphUsingAdjacencyList<Element, Weight>: Graph {
  public typealias Node = GraphNode<Element>
  private typealias InternalEdge = (weight: Weight, node: Node, isCopy: Bool)

  public private(set) var nodes: [Node]

  public var edges: [Edge<Element, Weight>] {
    var array = [Edge<Element, Weight>]()
    for (nodeA, list) in adjacencyLists {
      for (weight, nodeB, isCopy) in list where !isCopy {
        array.append(.init(from: nodeA, to: nodeB, weight: weight))
      }
    }
    return array
  }

  private var adjacencyLists = [Node: [InternalEdge]]()
  public let undirect: Bool

  public init(nodes: [Node], undirect: Bool) {
    self.nodes = nodes
    self.undirect = undirect
  }

  /// - Complexity: O(E)
  public func weight(from nodeA: Node, to nodeB: Node) -> Weight? {
    adjacencyLists[nodeA, default: []].first { $0.node == nodeB }?.weight
  }

  public func addEdge(from nodeA: Node, to nodeB: Node, weight: Weight) {
    func add(from nodeA: Node, to nodeB: Node, weight: Weight, isCopy: Bool) {
      adjacencyLists[nodeA, default: []].append((weight: weight, node: nodeB, isCopy: isCopy))
    }

    add(from: nodeA, to: nodeB, weight: weight, isCopy: false)
    if undirect {
      add(from: nodeB, to: nodeA, weight: weight, isCopy: true)
    }
  }

  public func removeEdge(from nodeA: Node, to nodeB: Node) {
    func remove(from nodeA: Node, to nodeB: Node) {
      let index = adjacencyLists[nodeA, default: []].firstIndex(where: { $0.node == nodeB })!
      adjacencyLists[nodeA, default: []].remove(at: index)
    }
    remove(from: nodeA, to: nodeB)
    if undirect {
      remove(from: nodeB, to: nodeA)
    }
  }

  public func nodesAdjacent(to node: Node) -> [Node] {
    adjacencyLists[node, default: []].map(\.node)
  }

}
