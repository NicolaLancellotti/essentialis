import Foundation

extension Array where Element: Equatable {

  public func countElement(_ element: Element) -> Int {
    filter { $0 == element }.count
  }

}

extension Array where Element: Hashable {

  public func countElements() -> [Element: Int] {
    var dic = [Element: Int]()
    for element in self {
      dic[element, default: 0] += 1
    }
    return dic
  }

}
