import RegexBuilder

extension String {

  public func splitByNewline() -> [String.SubSequence] {
    split(whereSeparator: \.isNewline)
  }

  public func splitByTwoNewlines() -> [String.SubSequence] {
    let regex = Regex {
      CharacterClass.newlineSequence
      CharacterClass.newlineSequence
    }
    return self.split(separator: regex)
  }

}

extension String.SubSequence {

  public func splitByNewline() -> [String.SubSequence] {
    split(whereSeparator: \.isNewline)
  }

  public func splitByWhitespace() -> [String.SubSequence] {
    split(whereSeparator: \.isWhitespace)
  }

}
