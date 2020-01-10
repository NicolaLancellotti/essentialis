import Essentialis
import XCTest

final class GraphUsingIndirectAdjacencyMatrixTests: XCTestCase {

  func test_edges() {
    let nodeA = GraphNode(info: "A")
    let nodeB = GraphNode(info: "B")
    let graph = GraphUsingIndirectAdjacencyMatrix<String, Void>(nodes: [nodeA, nodeB])

    XCTAssertFalse(graph.hasEdge(from: nodeA, to: nodeB))
    XCTAssertFalse(graph.hasEdge(from: nodeB, to: nodeA))

    graph.addEdge(from: nodeA, to: nodeB)

    XCTAssertTrue(graph.hasEdge(from: nodeA, to: nodeB))
    XCTAssertFalse(graph.hasEdge(from: nodeB, to: nodeA))

    graph.removeEdge(from: nodeA, to: nodeB)

    XCTAssertFalse(graph.hasEdge(from: nodeA, to: nodeB))
    XCTAssertFalse(graph.hasEdge(from: nodeB, to: nodeA))
  }

}
