extension Tensor {

  public var is2D: Bool {
    shape.count == 2
  }

  public var is2DSquare: Bool {
    is2D && shape[0] == shape[1]
  }

}

extension Tensor where Element: Numeric {

  public static func make2DIdentity(_ n: Int) -> Self {
    var tensor = Tensor(dimensions: [n, n], repeating: .zero)
    for i in 0..<n {
      tensor[i, i] = 1
    }
    return tensor
  }

  static public func multiply2D(_ lhs: Self, _ rhs: Self) -> Self {
    precondition(lhs.is2D && rhs.is2D && lhs.shape[1] == rhs.shape[0])
    let rows = lhs.shape[0]
    let columns = rhs.shape[1]
    let commonDimension = lhs.shape[1]
    var tensor = Tensor(dimensions: [rows, columns], repeating: .zero)
    for row in 0..<rows {
      for col in 0..<columns {
        var value = Element.zero
        for i in 0..<commonDimension {
          value += lhs[row, i] * rhs[i, col]
        }
        tensor[row, col] = value
      }
    }
    return tensor
  }

  public func power2D(_ n: Int) -> Self {
    precondition(is2DSquare && n >= 0)
    switch n {
    case 0: return Tensor.make2DIdentity(shape[0])
    case 1: return self
    default:
      var tensor = power2D(n / 2)
      tensor = Tensor.multiply2D(tensor, tensor)
      if !n.isMultiple(of: 2) {
        tensor = Tensor.multiply2D(tensor, self)
      }
      return tensor
    }
  }

}

// MARK: - Description

extension Tensor {

  public func description2D(minLength: Int? = nil, header: Bool = false) -> String {
    precondition(is2D)
    let minLength = minLength ?? 0

    var s = ""
    let last = dim(1) - 1

    if header {
      print(" ", terminator: "", to: &s)
      for j in 0..<dim(1) {
        let value = "\(j)".padLeft(minLength: minLength)
        print(value, terminator: j != last ? "," : "", to: &s)
      }
      print("", to: &s)
    }

    for i in 0..<dim(0) {
      print("[", terminator: "", to: &s)
      for j in 0..<dim(1) {
        let value = "\(self[i, j])".padLeft(minLength: minLength)
        print(value, terminator: j != last ? "," : "", to: &s)
      }

      if header {
        let value = "\(i)".padLeft(minLength: minLength)
        print("] \(value)", to: &s)
      } else {
        print("]", to: &s)
      }
    }
    return s
  }

}

extension Tensor where Element: SignedNumeric & Comparable & CustomStringConvertible {

  public func description2DAutomaticLength(header: Bool = false) -> String {
    var minLength: Int? = nil
    if let length1 = self.array.max().map({ "\($0)" })?.count,
      let length2 = self.array.min().map({ "\($0)" })?.count
    {
      minLength = max(length1, length2)
    }
    return description2D(minLength: minLength, header: header)
  }

}
