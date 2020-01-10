public enum DP {
  public static func cutRod(prices: [Int], length: Int) -> (price: Int, cuts: [Int]) {
    var bestCuts = Tensor(dimensions: [length + 1], repeating: -1)
    var table = Tensor(dimensions: [length + 1], repeating: -1)
    
    table[0] = 0
    for index in 1...length {
      for leftCut in 1...index {
        let reminder = index - leftCut
        let value = prices[leftCut] + table[reminder]
        if value > table[index] {
          table[index] = value
          bestCuts[index] = leftCut
        }
      }
    }
    
    var cuts = [Int]()
    var index = length
    while index > 0 {
      let cut = bestCuts[index]
      cuts.append(cut)
      index -= cut
    }
    
    return (price: table[length], cuts: cuts)
  }
}
