//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class Parser {
    private(set) var tokens: [SyntaxToken] = []
    private var _position: Int
    public var diagnostics: [String] = []

    private var current: SyntaxToken {
        get {
            peek(offset: 0)
        }
    }

    init(text: String) {
        _position = 0
        let lexer = Lexer(text: text)
        var token: SyntaxToken

        repeat {
            token = lexer.nextToken()

            if token.kind != .whitespaceToken && token.kind != .badToken {
                tokens.append(token)
            }
        } while token.kind != .endOfFileToken


        diagnostics.append(contentsOf: lexer.diagnostics)
    }

    func peek(offset: Int) -> SyntaxToken {
        let index = _position + offset
        if index >= tokens.count {
            return tokens.last!
        }

        return tokens[index]
    }

    func nextToken() -> SyntaxToken {
        let cur = current
        _position += 1
        return cur
    }

    func match(kind: SyntaxKind) -> SyntaxToken {
        if current.kind == kind {
            return nextToken()
        }

        diagnostics.append("Error: Unexpected token: '\(current.kind)', expected: '\(kind)'")

        return SyntaxToken(kind: kind, position: current.position, text: "", value: nil)
    }

    func parseExpression() -> SyntaxNode {
        parseTerm()
    }

    func parse() -> SyntaxTree {
        let expression = parseTerm()
        let endOfFileToken = match(kind: .endOfFileToken)

        return SyntaxTree(diagnostics: diagnostics, root: expression, endOfFileToken: endOfFileToken)
    }

    func parseTerm() -> SyntaxNode {
        var left = parseFactor()

        let operationKinds: [SyntaxKind] = [.plusToken, .minusToken]

        while operationKinds.contains(current.kind) {
            let operatorToken = nextToken()
            let right = parseFactor()
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }

        return left
    }

    func parseFactor() -> SyntaxNode {
        var left = parsePrimaryExpression()

        let operationKinds: [SyntaxKind] = [.startToken, .slashToken]

        while operationKinds.contains(current.kind) {
            let operatorToken = nextToken()
            let right = parsePrimaryExpression()
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }

        return left
    }

    func parsePrimaryExpression() -> SyntaxNode {
        if current.kind == .openParenthesisToken {
            let left = nextToken()
            let expression = parseExpression()
            let right = match(kind: .closeParenthesisToken)

            return ParenthesizedExpressionToken(openParenthesisToken: left, expression: expression, closeParenthesisToken: right)
        }

        let numberToken = match(kind: .numberToken)

        return NumberExpressionSyntax(numberToken: numberToken)
    }


}
