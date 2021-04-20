//
// Created by Serghei Grigoruta on 18.04.2021.
//

class Binder {
    private(set) var diagnostics: [String] = []

    func bindExpression(syntax: ExpressionSyntax) -> BoundExpression {
        switch syntax.kind {
        case .literalExpression:
            return bindLiteralExpression(syntax: syntax as! LiteralExpressionSyntax)
        case .unaryExpression:
            return bindUnaryExpression(syntax: syntax as! UnaryExpressionSyntax)
        case .binaryExpression:
            return bindBinaryExpression(syntax: syntax as! BinaryExpressionSyntax)
        default:
            fatalError("Unexpected Syntax: '\(syntax.kind)'")
        }
    }

    private func bindUnaryExpression(syntax: UnaryExpressionSyntax) -> BoundExpression {
        let boundOperand = bindExpression(syntax: syntax.operand)

        guard let boundOperator = BoundUnaryOperator.bind(
                syntaxKind: syntax.operatorToken.kind,
                operandType: boundOperand.type
        ) else {
            diagnostics.append("Unary operator '\(syntax.operatorToken.text)' is not defined for type '\(boundOperand.type)'")
            return boundOperand
        }

        return BoundUnaryExpression(op: boundOperator, operand: boundOperand)
    }

    private func bindBinaryExpression(syntax: BinaryExpressionSyntax) -> BoundExpression {
        let boundLeft = bindExpression(syntax: syntax.left)
        let boundRight = bindExpression(syntax: syntax.right)

        guard let boundOperator = BoundBinaryOperator.bind(
                syntaxKind: syntax.operatorToken.kind,
                leftType: boundLeft.type,
                rightType: boundRight.type
        ) else {
            diagnostics.append("Binary operator '\(syntax.operatorToken.text)' is not defined for types '\(boundLeft.type)' and '\(boundRight.type)'")
            return boundLeft
        }

        return BoundBinaryExpression(left: boundLeft, op: boundOperator, right: boundRight)
    }

    private func bindLiteralExpression(syntax: LiteralExpressionSyntax) -> BoundExpression {
        let value = syntax.value ?? 0

        return BoundLiteralExpression(value: value)
    }
}
