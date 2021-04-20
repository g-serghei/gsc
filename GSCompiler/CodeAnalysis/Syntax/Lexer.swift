//
// Created by Serghei Grigoruta on 17.04.2021.
//

class Lexer {
    private var text: String
    private var position: Int
    public var diagnostics: [String] = []

    private var current: Character {
        peek(offset: 0)
    }

    private var lookAhead: Character {
        peek(offset: 1)
    }

    init(text: String) {
        self.text = text
        position = 0
    }

    private func next() {
        position += 1
    }

    private func peek(offset: Int) -> Character {
        let index = position + offset

        if index >= text.count {
            return "\0"
        }

        return Array(text)[index]
    }

    func lex() -> SyntaxToken {
        if position >= text.count {
            return SyntaxToken(kind: .endOfFileToken, position: position, text: "\0", value: nil)
        }

        if current.isWhitespace {
            let start = position

            while current.isWhitespace {
                next()
            }

            let length = position - start
            let startIndex = text.index(text.startIndex, offsetBy: start)
            let endIndex = text.index(text.startIndex, offsetBy: start + length)
            let text = String(self.text[startIndex..<endIndex])

            return SyntaxToken(kind: .whitespaceToken, position: start, text: text, value: nil)
        }

        if current.isNumber {
            let start = position

            while current.isNumber {
                next()
            }

            let length = position - start
            let startIndex = text.index(text.startIndex, offsetBy: start)
            let endIndex = text.index(text.startIndex, offsetBy: start + length)
            let text = String(self.text[startIndex..<endIndex])

            guard let value = Int(text) else {
                diagnostics.append("The number '\(text)' is not a valid Int32")

                return SyntaxToken(kind: .numberToken, position: start, text: text, value: 0)
            }

            return SyntaxToken(kind: .numberToken, position: start, text: text, value: value as Any)
        }

        if current.isLetter {
            let start = position

            while current.isLetter {
                next()
            }

            let length = position - start
            let startIndex = text.index(text.startIndex, offsetBy: start)
            let endIndex = text.index(text.startIndex, offsetBy: start + length)
            let text = String(self.text[startIndex..<endIndex])
            let kind = SyntaxFacts.getKeywordKind(text: text)

            return SyntaxToken(kind: kind, position: start, text: text, value: nil)
        }

        var kind: SyntaxKind = .badToken

        var text = String(current)
        var positionIncrement = 1

        switch current {
        case "+":
            kind = .plusToken
        case "-":
            kind = .minusToken
        case "*":
            kind = .startToken
        case "/":
            kind = .slashToken
        case "(":
            kind = .openParenthesisToken
        case ")":
            kind = .closeParenthesisToken
        case "&" where lookAhead == "&":
            text = "&&"
            positionIncrement = 2
            kind = .ampersandAmpersandToken
        case "|" where lookAhead == "|":
            text = "||"
            positionIncrement = 2
            kind = .pipePipeToken
        case "=" where lookAhead == "=":
            text = "=="
            positionIncrement = 2
            kind = .equalsEqualsToken
        case "!":
            if lookAhead == "=" {
                text = "!="
                positionIncrement = 2
                kind = .bangEqualsToken
            } else {
                kind = .bangToken
            }
        default:
            kind = .badToken
        }

        if kind == .badToken {
            diagnostics.append("Error: Bad character input: '\(current)'")
        }

        let token = SyntaxToken(kind: kind, position: position, text: text, value: nil);

        position += positionIncrement

        return token
    }
}
