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

        guard let boundOperatorKind = bindUnaryOperatorKind(
                kind: syntax.operatorToken.kind,
                operandType: boundOperand.nodeType
        ) else {
            diagnostics.append("Unary operator '\(syntax.operatorToken.text)' is not defined for type '\(boundOperand.nodeType)'")
            return boundOperand
        }

        return BoundUnaryExpression(operatorKind: boundOperatorKind, operand: boundOperand)
    }

    private func bindBinaryExpression(syntax: BinaryExpressionSyntax) -> BoundExpression {
        let boundLeft = bindExpression(syntax: syntax.left)
        let boundRight = bindExpression(syntax: syntax.right)

        guard let boundOperatorKind = bindBinaryOperatorKind(
                kind: syntax.operatorToken.kind,
                leftType: boundLeft.nodeType,
                rightType: boundRight.nodeType
        ) else {
            diagnostics.append("Binary operator '\(syntax.operatorToken.text)' is not defined for types '\(boundLeft.nodeType)' and '\(boundRight.nodeType)'")
            return boundLeft
        }

        return BoundBinaryExpression(left: boundLeft, operatorKind: boundOperatorKind, right: boundRight)
    }

    private func bindLiteralExpression(syntax: LiteralExpressionSyntax) -> BoundExpression {
        let value = syntax.value ?? 0

        return BoundLiteralExpression(value: value)
    }

    private func bindUnaryOperatorKind(kind: SyntaxKind, operandType: Any) -> BoundUnaryOperatorKind? {
        if !(operandType is Int.Type) {
            return nil
        }

        switch kind {
        case .plusToken:
            return .identity
        case .minusToken:
            return .negation
        default:
            fatalError("Unexpected unary operator: '\(kind)'")
        }
    }

    private func bindBinaryOperatorKind(kind: SyntaxKind, leftType: Any, rightType: Any) -> BoundBinaryOperatorKind? {
        if !(leftType is Int.Type) || !(rightType is Int.Type) {
            return nil
        }

        switch kind {
        case .plusToken:
            return .addition
        case .minusToken:
            return .subtraction
        case .startToken:
            return .multiplication
        case .slashToken:
            return .division
        default:
            fatalError("Unexpected binary operator: '\(kind)'")
        }
    }
}
