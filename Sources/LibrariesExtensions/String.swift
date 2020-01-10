import Foundation

extension String {

  public init?(
    forResource name: String, withExtension ext: String, subdirectory subpath: String? = nil,
    in bundle: Bundle
  ) {
    guard let url = bundle.url(forResource: name, withExtension: ext, subdirectory: subpath),
      let string = try? String(contentsOf: url)
    else {
      return nil
    }
    self = string
  }

}

extension String {

  public func padLeft(minLength: Int) -> String {
    let spaces = minLength - count
    guard spaces > 0 else {
      return self
    }
    return repeatElement(" ", count: spaces).joined() + self
  }
}
