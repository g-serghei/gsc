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
            token = lexer.lex()

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

    func matchToken(kind: SyntaxKind) -> SyntaxToken {
        if current.kind == kind {
            return nextToken()
        }

        diagnostics.append("Error: Unexpected token: '\(current.kind)', expected: '\(kind)'")

        return SyntaxToken(kind: kind, position: current.position, text: "", value: nil)
    }

    func parse() -> SyntaxTree {
        let expression = parseExpression()
        let endOfFileToken = matchToken(kind: .endOfFileToken)

        return SyntaxTree(diagnostics: diagnostics, root: expression, endOfFileToken: endOfFileToken)
    }

    func parseExpression(parentPrecedence: Int = 0) -> SyntaxNode {
        var left: SyntaxNode

        let unaryOperatorPrecedence = current.kind.getUnaryOperatorPrecedence()

        if unaryOperatorPrecedence != 0 && unaryOperatorPrecedence >= parentPrecedence {
            let operatorToken = nextToken()
            let operand = parseExpression(parentPrecedence: unaryOperatorPrecedence)

            left = UnaryExpressionSyntax(operatorToken: operatorToken, operand: operand)
        } else {
            left = parsePrimaryExpression()
        }

        while true {
            let precedence = current.kind.getBinaryOperatorPrecedence()

            if precedence == 0 || precedence <= parentPrecedence {
                break
            }

            let operatorToken = nextToken()
            let right = parseExpression(parentPrecedence: precedence)

            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }

        return left
    }

    func parsePrimaryExpression() -> SyntaxNode {
        if current.kind == .openParenthesisToken {
            let left = nextToken()
            let expression = parseExpression()
            let right = matchToken(kind: .closeParenthesisToken)

            return ParenthesizedExpressionToken(openParenthesisToken: left, expression: expression, closeParenthesisToken: right)
        }

        let numberToken = matchToken(kind: .numberToken)

        return LiteralExpressionSyntax(literalToken: numberToken)
    }


}
