public protocol Graph<Element, Weight> {
  associatedtype Element
  associatedtype Weight
  typealias Node = GraphNode<Element>

  var nodes: [Node] { get }

  var edges: [Edge<Element, Weight>] { get }

  func addEdge(from nodeA: Node, to nodeB: Node, weight: Weight)

  func removeEdge(from nodeA: Node, to nodeB: Node)

  func weight(from nodeA: Node, to nodeB: Node) -> Weight?

  func nodesAdjacent(to node: Node) -> [Node]

  var undirect: Bool { get }

  init(nodes: [Node], undirect: Bool)
}

extension Graph {

  public init(nodes: [Node]) {
    self = Self.init(nodes: nodes, undirect: false)
  }

  public func hasEdge(from nodeA: Node, to nodeB: Node) -> Bool {
    weight(from: nodeA, to: nodeB) != nil
  }

}

extension Graph where Weight == Void {
  public func addEdge(from nodeA: Node, to nodeB: Node) {
    addEdge(from: nodeA, to: nodeB, weight: ())
  }
}

public final class GraphNode<Element>: Equatable, Hashable {
  public var info: Element

  public init(info: Element) {
    self.info = info
  }

  public static func == (lhs: GraphNode, rhs: GraphNode) -> Bool {
    ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
}

public struct Edge<Element, Weight> {
  public let from: GraphNode<Element>
  public let to: GraphNode<Element>
  public let weight: Weight
}
