public final class GraphUsingIndirectAdjacencyMatrix<Element, Weight>: Graph {
  public typealias Node = GraphNode<Element>

  public private(set) var nodes: [Node]

  public var edges: [Edge<Element, Weight>] {
    var array = [Edge<Element, Weight>]()
    let count = adjacencyMatrix.dim(0)
    for indexA in stride(from: 0, to: count, by: 1) {
      let end = undirect ? indexA + 1 : count
      for indexB in stride(from: 0, to: end, by: 1) {
        if let weight = adjacencyMatrix[indexA, indexB] {
          array.append(.init(from: indexToNode[indexA]!, to: indexToNode[indexB]!, weight: weight))
        }
      }
    }
    return array
  }

  private var adjacencyMatrix: Tensor<Weight?>
  private var nodeToIndex = [Node: Int]()
  private var indexToNode = [Int: Node]()
  public let undirect: Bool

  public init(nodes: [Node], undirect: Bool) {
    self.nodes = nodes
    for (index, node) in nodes.enumerated() {
      nodeToIndex[node] = index
      indexToNode[index] = node
    }
    adjacencyMatrix = Tensor(dimensions: [nodes.count, nodes.count], repeating: nil)
    self.undirect = undirect
  }

  /// - Complexity: O(1)
  public func weight(from nodeA: Node, to nodeB: Node) -> Weight? {
    adjacencyMatrix[nodeToIndex[nodeA]!, nodeToIndex[nodeB]!]
  }

  func updateAdjacencyMatrix(from nodeA: Node, to nodeB: Node, weight: Weight?) {
    let indexA = nodeToIndex[nodeA]!
    let indexB = nodeToIndex[nodeB]!
    adjacencyMatrix[indexA, indexB] = weight
    if undirect {
      adjacencyMatrix[indexB, indexA] = weight
    }
  }

  public func addEdge(from nodeA: Node, to nodeB: Node, weight: Weight) {
    updateAdjacencyMatrix(from: nodeA, to: nodeB, weight: weight)
  }

  public func removeEdge(from nodeA: Node, to nodeB: Node) {
    updateAdjacencyMatrix(from: nodeA, to: nodeB, weight: nil)
  }

  /// - Complexity: O(V)
  public func nodesAdjacent(to node: Node) -> [Node] {
    nodes.filter { self.hasEdge(from: node, to: $0) }
  }
}
