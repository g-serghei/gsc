//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class Lexer {
    private var text: String
    private var position: Int
    public var diagnostics: [String] = []

    private var current: Character {
        get {
            if position >= text.count {
                return "\0"
            }

            return Array(text)[position]
        }
    }

    init(text: String) {
        self.text = text
        position = 0
    }

    private func next() {
        position += 1
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

        var kind: SyntaxKind = .badToken

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
        default:
            kind = .badToken
        }

        if kind == .badToken {
            diagnostics.append("Error: Bad character input: '\(current)'")
        }

        let token = SyntaxToken(kind: kind, position: position, text: String(current), value: nil);

        next()

        return token
    }
}
