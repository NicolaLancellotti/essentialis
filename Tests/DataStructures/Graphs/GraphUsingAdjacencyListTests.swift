import Essentialis
import XCTest

final class GraphUsingAdjacencyListTests: XCTestCase {

  func test_edges() {
    let nodeA = GraphNode(info: "A")
    let nodeB = GraphNode(info: "B")
    let graph = GraphUsingAdjacencyList<String, Void>(nodes: [nodeA, nodeB])

    XCTAssertFalse(graph.hasEdge(from: nodeA, to: nodeB))
    XCTAssertFalse(graph.hasEdge(from: nodeB, to: nodeA))

    graph.addEdge(from: nodeA, to: nodeB)
    XCTAssertTrue(graph.hasEdge(from: nodeA, to: nodeB))
    XCTAssertFalse(graph.hasEdge(from: nodeB, to: nodeA))

    graph.addEdge(from: nodeB, to: nodeA)
    XCTAssertNotNil(graph.hasEdge(from: nodeA, to: nodeB))
    XCTAssertNotNil(graph.hasEdge(from: nodeB, to: nodeA))

    graph.removeEdge(from: nodeB, to: nodeA)
    XCTAssertTrue(graph.hasEdge(from: nodeA, to: nodeB))
    XCTAssertFalse(graph.hasEdge(from: nodeB, to: nodeA))
  }

}
