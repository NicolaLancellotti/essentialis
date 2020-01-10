import Essentialis
import XCTest

final class GraphsAlgorithmsTests: XCTestCase {

  func graphTypes<Element, Weight>(elementType: Element.Type, weightType: Weight.Type = Void.self)
    -> [any Graph<Element, Weight>.Type]
  {
    [
      GraphUsingAdjacencyList<Element, Weight>.self,
      GraphUsingIndirectAdjacencyMatrix<Element, Weight>.self,
    ]
  }

  // MARK: - BFS Tree

  func test_bfsTree() {
    for graphType in graphTypes(elementType: Int.self) {
      let nodes = [
        GraphNode(info: 0),
        GraphNode(info: 1),
        GraphNode(info: 2),
        GraphNode(info: 3),
        GraphNode(info: 4),
        GraphNode(info: 5),
        GraphNode(info: 6),
        GraphNode(info: 7),
        GraphNode(info: 8),
      ]

      let graph = graphType.init(nodes: nodes, undirect: true)

      graph.addEdge(from: nodes[0], to: nodes[1])
      graph.addEdge(from: nodes[0], to: nodes[2])
      graph.addEdge(from: nodes[0], to: nodes[3])
      graph.addEdge(from: nodes[0], to: nodes[4])
      graph.addEdge(from: nodes[1], to: nodes[4])
      graph.addEdge(from: nodes[1], to: nodes[8])
      graph.addEdge(from: nodes[2], to: nodes[5])
      graph.addEdge(from: nodes[2], to: nodes[6])
      graph.addEdge(from: nodes[3], to: nodes[5])
      graph.addEdge(from: nodes[3], to: nodes[8])
      graph.addEdge(from: nodes[5], to: nodes[7])
      graph.addEdge(from: nodes[6], to: nodes[7])
      graph.addEdge(from: nodes[7], to: nodes[8])

      let (tree, distances) = graph.bfsTree(root: nodes[5])
      for node in nodes {
        if let parent = tree.parent(of: node) {
          XCTAssertEqual(distances[node]!, distances[parent]! + 1)
        } else {
          XCTAssertEqual(distances[node]!, 0)
        }
      }
    }
  }

  // MARK: - DFS

  func test_dfs() {
    for graphType in graphTypes(elementType: String.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let nodeD = GraphNode(info: "D")
      let nodeE = GraphNode(info: "E")
      let graph = graphType.init(nodes: [nodeA, nodeB, nodeC, nodeD, nodeE])

      // A -> B -> C
      // B -> D
      graph.addEdge(from: nodeA, to: nodeB)
      graph.addEdge(from: nodeB, to: nodeC)
      graph.addEdge(from: nodeB, to: nodeD)

      do {
        var visited = [GraphNode<String>]()
        let delegate = graph.makeDFSDelegate()
        delegate.willVisitNode = { visited.append($0) }
        graph.dfs(delegate: delegate, root: nodeA)
        XCTAssertEqual(visited, [nodeA, nodeB, nodeC, nodeD])
      }

      do {
        var visited = [GraphNode<String>]()
        let delegate = graph.makeDFSDelegate()
        delegate.willVisitNode = { visited.append($0) }
        graph.dfs(delegate: delegate)
        XCTAssertEqual(visited, [nodeA, nodeB, nodeC, nodeD, nodeE])
      }
    }
  }

  // MARK: - DFS Tree

  func test_dfsTree() {
    for graphType in graphTypes(elementType: String.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let graph = graphType.init(nodes: [nodeA, nodeB, nodeC])

      graph.addEdge(from: nodeA, to: nodeB)

      let tree = graph.dfsTree(root: nodeA)
      XCTAssertNil(tree.parent(of: nodeA))
      XCTAssertEqual(tree.parent(of: nodeB), nodeA)
      XCTAssertNil(tree.parent(of: nodeC))
    }
  }

  // MARK: - Connected Components

  func test_connectedComponentsInUndirectedGraphUsingDFS() {
    for graphType in graphTypes(elementType: String.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let graph = graphType.init(nodes: [nodeA, nodeB, nodeC], undirect: true)
      graph.addEdge(from: nodeA, to: nodeB)

      let connectedComponents = graph.connectedComponentsInUndirectedGraphUsingDFS()
      let set = Set([
        Set([nodeA, nodeB]),
        Set([nodeC]),
      ])
      XCTAssertEqual(connectedComponents, set)
    }
  }

  func test_connectedComponentsInUndirectedGraphUsingDisjointSets() {
    for graphType in graphTypes(elementType: String.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let graph = graphType.init(nodes: [nodeA, nodeB, nodeC], undirect: true)
      graph.addEdge(from: nodeA, to: nodeB)

      let sets = graph.connectedComponentsInUndirectedGraphUsingDisjointSets()

      XCTAssertTrue(sets.sameComponents(nodeA, nodeB: nodeB))
      XCTAssertTrue(sets.sameComponents(nodeB, nodeB: nodeA))
      XCTAssertTrue(sets.sameComponents(nodeC, nodeB: nodeC))
      XCTAssertFalse(sets.sameComponents(nodeA, nodeB: nodeC))
      XCTAssertFalse(sets.sameComponents(nodeC, nodeB: nodeA))

      graph.addEdge(from: nodeA, to: nodeC)
      XCTAssertFalse(sets.sameComponents(nodeA, nodeB: nodeC))
    }
  }

  // MARK: - Sinks

  func test_universalSink_true() {
    for graphType in graphTypes(elementType: String.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let graph = graphType.init(nodes: [nodeA, nodeB, nodeC])

      //  A -> C <- B
      graph.addEdge(from: nodeA, to: nodeC)
      graph.addEdge(from: nodeB, to: nodeC)

      let universalSink = graph.universalSink!
      XCTAssertNotNil(graph.isUniversalSink(node: universalSink))
      XCTAssertTrue(universalSink === nodeC)
    }
  }

  func test_universalSink_false_1() {
    for graphType in graphTypes(elementType: String.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let graph = graphType.init(nodes: [nodeA, nodeB, nodeC])

      //  A -> C  B
      graph.addEdge(from: nodeA, to: nodeC)

      let universalSink = graph.universalSink
      XCTAssertNil(universalSink)
    }
  }

  func test_universalSink_false_2() {
    for graphType in graphTypes(elementType: String.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let graph = graphType.init(nodes: [nodeA, nodeB, nodeC])

      //  A <-> C <- B
      graph.addEdge(from: nodeA, to: nodeC)
      graph.addEdge(from: nodeB, to: nodeC)
      graph.addEdge(from: nodeC, to: nodeA)

      let universalSink = graph.universalSink
      XCTAssertNil(universalSink)
    }
  }

  // MARK: - Minimum Spanning Trees

  func test_mst() {
    for graphType in graphTypes(elementType: String.self, weightType: Int.self) {
      let nodeA = GraphNode(info: "A")
      let nodeB = GraphNode(info: "B")
      let nodeC = GraphNode(info: "C")
      let nodeD = GraphNode(info: "D")
      let nodeE = GraphNode(info: "E")
      let nodeF = GraphNode(info: "F")
      let nodeG = GraphNode(info: "G")
      let nodeH = GraphNode(info: "H")
      let nodeI = GraphNode(info: "I")

      let graph = graphType.init(
        nodes: [
          nodeA, nodeB, nodeC, nodeD, nodeE, nodeF, nodeG, nodeH, nodeI,
        ], undirect: true)
      graph.addEdge(from: nodeA, to: nodeB, weight: 4)
      graph.addEdge(from: nodeA, to: nodeH, weight: 8)
      graph.addEdge(from: nodeB, to: nodeC, weight: 8)
      graph.addEdge(from: nodeB, to: nodeH, weight: 11)
      graph.addEdge(from: nodeC, to: nodeD, weight: 7)
      graph.addEdge(from: nodeC, to: nodeF, weight: 4)
      graph.addEdge(from: nodeC, to: nodeI, weight: 2)
      graph.addEdge(from: nodeD, to: nodeE, weight: 9)
      graph.addEdge(from: nodeD, to: nodeF, weight: 14)
      graph.addEdge(from: nodeE, to: nodeF, weight: 10)
      graph.addEdge(from: nodeF, to: nodeG, weight: 2)
      graph.addEdge(from: nodeG, to: nodeH, weight: 1)
      graph.addEdge(from: nodeG, to: nodeI, weight: 6)
      graph.addEdge(from: nodeH, to: nodeI, weight: 7)

      do {
        let weight = graph.mstKruskal().reduce(0) { $0 + $1.weight }
        XCTAssertEqual(weight, 37)
      }
      do {
        let weight = graph.mstPrim().reduce(0) { $0 + $1.weight }
        XCTAssertEqual(weight, 37)
      }
    }
  }
}
