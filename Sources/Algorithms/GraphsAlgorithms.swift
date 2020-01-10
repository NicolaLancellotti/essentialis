// MARK: - BFS

public class BFSDelegate<Element> {
  public typealias Node = GraphNode<Element>

  public var willVisitNewRoot: ((Node) -> Void)?
  public var willVisitChild: ((_ parent: Node, _ child: Node) -> Void)?
}

extension Graph {

  /// - Complexity: IndirectAdjacencyMatrix: O(V^2)
  /// - Complexity: AdjacencyList: O(V + E)
  public func bfs(delegate: BFSDelegate<Element>, root: Node? = nil) {
    var enqueued = Set<Node>()

    func bfs(_ node: Node) {
      var queue = QueueUsingList<Node>()
      queue.enqueue(node)
      enqueued.insert(node)

      while let node = queue.dequeue() {
        for adj in self.nodesAdjacent(to: node) where !enqueued.contains(adj) {
          delegate.willVisitChild?(node, adj)
          queue.enqueue(adj)
          enqueued.insert(adj)
        }
      }
    }

    let nodes = if let root { [root] } else { nodes }
    for node in nodes where !enqueued.contains(node) {
      delegate.willVisitNewRoot?(node)
      bfs(node)
    }
  }

}

// MARK: - DFS Tree

extension Graph {

  public func bfsTree(root: Node?) -> (
    tree: TreeUsingParentDictionary<Node>, distances: [Node: Int]
  ) {
    var tree = TreeUsingParentDictionary<Node>()
    var distances = [Node: Int]()
    let delegate = BFSDelegate<Element>()
    delegate.willVisitNewRoot = { node in
      distances[node] = 0

    }
    delegate.willVisitChild = { parent, child in
      tree.addChild(child, to: parent)
      distances[child] = distances[parent, default: 0] + 1
    }
    bfs(delegate: delegate, root: root)
    return (tree, distances)
  }

}

// MARK: - DFS

public class DFSDelegate<Element> {
  public typealias Node = GraphNode<Element>

  public var willVisitNewRoot: ((Node) -> Void)?
  public var didVisitNewRoot: ((Node) -> Void)?
  public var willVisitNode: ((Node) -> Void)?
  public var didVisitNode: ((Node) -> Void)?
  public var willVisitChild: ((_ parent: Node, _ child: Node) -> Void)?
}

extension Graph {

  public func makeDFSDelegate() -> DFSDelegate<Element> {
    DFSDelegate()
  }

  /// - Complexity: IndirectAdjacencyMatrix: O(V^2)
  /// - Complexity: AdjacencyList: O(V + E)
  public func dfs(delegate: DFSDelegate<Element>, root: Node? = nil) {
    var visited = Set<Node>()

    func dfs(_ node: Node) {
      delegate.willVisitNode?(node)
      visited.insert(node)

      for child in nodesAdjacent(to: node) where !visited.contains(child) {
        delegate.willVisitChild?(node, child)
        dfs(child)
      }

      delegate.didVisitNode?(node)
    }

    let nodes = if let root { [root] } else { nodes }
    for node in nodes where !visited.contains(node) {
      delegate.willVisitNewRoot?(node)
      dfs(node)
      delegate.didVisitNewRoot?(node)
    }
  }

}

// MARK: - DFS Tree

extension Graph {

  public func dfsTree(root: Node?) -> TreeUsingParentDictionary<Node> {
    var tree = TreeUsingParentDictionary<Node>()
    let delegate = DFSDelegate<Element>()
    delegate.willVisitChild = { parent, child in tree.addChild(child, to: parent) }
    dfs(delegate: delegate, root: root)
    return tree
  }

}

// MARK: - Connected Components - DFS

extension Graph {

  /// - Complexity: IndirectAdjacencyMatrix: O(V^2)
  /// - Complexity: AdjacencyList: O(V + E)
  public func connectedComponentsInUndirectedGraphUsingDFS() -> Set<Set<Node>> {
    guard undirect else { fatalError("The graph must be undirected") }
    var connectedComponents = Set<Set<Node>>()
    var current = Set<Node>()

    let delegate = DFSDelegate<Element>()
    delegate.willVisitNewRoot = { _ in current = Set<Node>() }
    delegate.willVisitNode = { current.insert($0) }
    delegate.didVisitNewRoot = { _ in connectedComponents.insert(current) }

    dfs(delegate: delegate)
    return connectedComponents
  }

}

// MARK: - Connected Components - DisjointSets

public class ConnectedComponents<Element, Weight> {
  private let graph: any Graph<Element, Weight>
  private let disjointSets = DisjointSets()
  private var nodeToSet = [GraphNode<Element>: DisjointSets.Element]()

  init(graph: any Graph<Element, Weight>) {
    self.graph = graph
  }

  fileprivate func find() {
    for node in graph.nodes {
      nodeToSet[node] = disjointSets.makeSet()
    }

    for nodeA in graph.nodes {
      for nodeB in graph.nodesAdjacent(to: nodeA) {
        addEdge(nodeA, nodeB)
      }
    }
  }

  public func addEdge(_ nodeA: GraphNode<Element>, _ nodeB: GraphNode<Element>) {
    let elems = (nodeToSet[nodeA]!, nodeToSet[nodeB]!)
    if disjointSets.findSet(elems.0) != disjointSets.findSet(elems.1) {
      disjointSets.union(elems.0, elems.1)
    }
  }

  public func sameComponents(_ nodeA: GraphNode<Element>, nodeB: GraphNode<Element>) -> Bool {
    let elems = (nodeToSet[nodeA]!, nodeToSet[nodeB]!)
    return disjointSets.findSet(elems.0) == disjointSets.findSet(elems.1)
  }

}

extension Graph {

  public func connectedComponentsInUndirectedGraphUsingDisjointSets() -> ConnectedComponents<
    Element, Weight
  > {
    guard undirect else { fatalError("The graph must be undirected") }
    let connectedComponents = ConnectedComponents<Element, Weight>(graph: self)
    connectedComponents.find()
    return connectedComponents
  }

}

// MARK: - Sinks

extension Graph {

  ///  An universal sink, in a directed graph, is a vertex with
  ///  out-degree equals 0 and in-degree equals V - 1.
  /// - Complexity: IndirectAdjacencyMatrix: O(V)
  /// - Complexity: AdjacencyList: O(VE)
  public func isUniversalSink(node: Node) -> Bool {
    for n in nodes where n != node {
      if hasEdge(from: node, to: n) || !hasEdge(from: n, to: node) {
        return false
      }
    }
    return true
  }

  /// - Complexity: IndirectAdjacencyMatrix: O(V)
  /// - Complexity: AdjacencyList: O(VE)
  public var universalSink: Node? {
    guard var nodeA = nodes.first else { return nil }
    for nodeB in nodes.dropFirst() {
      // hasEdge(from: nodeA, to: nodeB) -> nodeA is not an universal sink
      // otherwise                       -> nodeB is not an universal sink
      if hasEdge(from: nodeA, to: nodeB) {
        nodeA = nodeB
      }
    }
    return isUniversalSink(node: nodeA) ? nodeA : nil
  }

}

// MARK: - Minimum Spanning Trees - Kruskal

extension Graph where Weight: Comparable {
  public func mstKruskal() -> [Edge<Element, Weight>] {
    guard undirect else { fatalError("The graph must be undirected") }
    let disjointSets = DisjointSets()
    let nodeToSet = Dictionary(
      uniqueKeysWithValues: nodes.lazy.map { ($0, disjointSets.makeSet()) })

    var mstEdges = [Edge<Element, Weight>]()
    for edge in edges.sorted(by: { $0.weight < $1.weight }) {
      let (setA, setB) = (nodeToSet[edge.from]!, nodeToSet[edge.to]!)
      if disjointSets.findSet(setA) != disjointSets.findSet(setB) {
        mstEdges.append(edge)
        disjointSets.union(setA, setB)
      }
    }
    return mstEdges
  }
}

extension Graph where Weight == Int {
  public func mstPrim() -> [Edge<Element, Weight>] {
    guard undirect else { fatalError("The graph must be undirected") }
    guard let first = nodes.first else { return [] }

    var parents = [GraphNode<Element>: GraphNode<Element>]()
    var keys = [GraphNode<Element>: Int]()
    keys[first] = 0

    // Use Fibonacci heap when implemented
    var queue = MinBinaryHeap(elements: nodes.map { (Int.max, $0) })
    var queueContents = Set(nodes)

    while let node = queue.extract() {
      queueContents.remove(node)
      for adj in nodesAdjacent(to: node) where queueContents.contains(adj) {
        let weight = weight(from: node, to: adj)!
        let key = keys[adj]
        if key == nil || weight < key! {
          parents[adj] = node
          keys[adj] = weight

          let index = queue.firstIndex { key, elem in elem === adj }
          queue.changeKeyForElement(at: index!, to: weight)
        }
      }
    }

    let mstEdges = parents.map { node, parent in
      Edge(from: parent, to: node, weight: weight(from: parent, to: node)!)
    }
    return mstEdges
  }
}
