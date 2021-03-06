//
// Created by Serghei Grigoruta on 17.04.2021.
//

class Parser {
    private(set) var tokens: [SyntaxToken] = []
    private var _position: Int
    public var diagnostics: DiagnosticBag = DiagnosticBag()

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

        diagnostics.reportUnexpectedToken(span: current.span, actualKind: current.kind, expectedKind: kind)

        return SyntaxToken(kind: kind, position: current.position, text: "", value: nil)
    }

    func parse() -> SyntaxTree {
        let expression = parseExpression()
        let endOfFileToken = matchToken(kind: .endOfFileToken)

        return SyntaxTree(diagnostics: diagnostics, root: expression, endOfFileToken: endOfFileToken)
    }

    func parseExpression() -> ExpressionSyntax {
        parseAssignmentExpression()
    }

    func parseAssignmentExpression() -> ExpressionSyntax {
        if peek(offset: 0).kind == .identifierToken && peek(offset: 1).kind == .equalsToken {
            let identifierToken = nextToken()
            let operatorToken = nextToken()
            let right = parseAssignmentExpression()

            return AssignmentExpressionSyntax(identifierToken: identifierToken, equalsToken: operatorToken, expression: right)
        }

        return parseBinaryExpression()
    }

    func parseBinaryExpression(parentPrecedence: Int = 0) -> ExpressionSyntax {
        var left: ExpressionSyntax

        let unaryOperatorPrecedence = current.kind.getUnaryOperatorPrecedence()

        if unaryOperatorPrecedence != 0 && unaryOperatorPrecedence >= parentPrecedence {
            let operatorToken = nextToken()
            let operand = parseBinaryExpression(parentPrecedence: unaryOperatorPrecedence)

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
            let right = parseBinaryExpression(parentPrecedence: precedence)

            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }

        return left
    }

    func parsePrimaryExpression() -> ExpressionSyntax {
        switch current.kind {
        case .openParenthesisToken:
            let left = nextToken()
            let expression = parseExpression()
            let right = matchToken(kind: .closeParenthesisToken)

            return ParenthesizedExpressionSyntax(openParenthesisToken: left, expression: expression, closeParenthesisToken: right)
        case .trueKeyword, .falseKeyword:
            let keywordToken = nextToken()
            let value = keywordToken.kind == .trueKeyword

            return LiteralExpressionSyntax(literalToken: keywordToken, value: value)
        case .identifierToken:
            let identifierToken = nextToken()

            return NameExpressionSyntax(identifierToken: identifierToken)
        default:
            let numberToken = matchToken(kind: .numberToken)

            return LiteralExpressionSyntax(literalToken: numberToken)
        }
    }


}
