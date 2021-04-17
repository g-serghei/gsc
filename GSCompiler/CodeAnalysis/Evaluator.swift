//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class Evaluator {
    private var root: SyntaxNode

    init(root: SyntaxNode) {
        self.root = root
    }

    func evaluate() -> Int {
        try! evaluateExpression(node: root)
    }

    func evaluateExpression(node: SyntaxNode) throws -> Int {
        if let n = node as? LiteralExpressionSyntax {
            return n.literalToken.value as! Int
        }

        if let u = node as? UnaryExpressionSyntax {
            let operand = try evaluateExpression(node: u.operand)

            switch u.operatorToken.kind {
            case .plusToken:
                return operand;
            case .minusToken:
                return -operand;
            default:
                throw SyntaxError.unexpectedUnaryOperator(kind: u.operatorToken.kind)
            }
        }

        if let b = node as? BinaryExpressionSyntax {
            let left = try evaluateExpression(node: b.left)
            let right = try evaluateExpression(node: b.right)

            switch b.operatorToken.kind {
            case .plusToken:
                return left + right
            case .minusToken:
                return left - right
            case .startToken:
                return left * right
            case .slashToken:
                return left / right
            default:
                throw SyntaxError.unexpectedBinaryOperator(kind: b.operatorToken.kind)
            }
        }

        if let p = node as? ParenthesizedExpressionToken {
            return try evaluateExpression(node: p.expression)
        }

        throw SyntaxError.unexpectedNode(kind: node.kind)
    }
}
