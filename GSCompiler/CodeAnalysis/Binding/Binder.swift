//
// Created by Serghei Grigoruta on 18.04.2021.
//

class Binder {
    private(set) var diagnostics: DiagnosticBag = DiagnosticBag()
    private(set) var variables: Dictionary<String, Any>

    init(variables: inout Dictionary<String, Any>) {
        self.variables = variables
    }

    func bindExpression(syntax: ExpressionSyntax) -> BoundExpression {
        switch syntax.kind {
        case .parenthesizedExpression:
            return bindParenthesizedExpression(syntax: syntax as! ParenthesizedExpressionSyntax)
        case .literalExpression:
            return bindLiteralExpression(syntax: syntax as! LiteralExpressionSyntax)
        case .nameExpression:
            return bindNameExpression(syntax: syntax as! NameExpressionSyntax)
        case .assignmentExpression:
            return bindAssignmentExpression(syntax: syntax as! AssignmentExpressionSyntax)
        case .unaryExpression:
            return bindUnaryExpression(syntax: syntax as! UnaryExpressionSyntax)
        case .binaryExpression:
            return bindBinaryExpression(syntax: syntax as! BinaryExpressionSyntax)
        default:
            fatalError("Unexpected Syntax: '\(syntax.kind)'")
        }
    }

    private func bindAssignmentExpression(syntax: AssignmentExpressionSyntax) -> BoundExpression {
        let name = syntax.identifierToken.text
        let boundExpression = bindExpression(syntax: syntax.expression)

        return BoundAssignmentExpression(name: name, expression: boundExpression)
    }

    private func bindNameExpression(syntax: NameExpressionSyntax) -> BoundExpression {
        let name = syntax.identifierToken.text

        print("name", name)

        guard let value = variables[name] else {
            diagnostics.reportUndefinedName(span: syntax.identifierToken.span, name: name)

            return BoundLiteralExpression(value: 0)
        }

        let type: DataType = .int

        return BoundVariableExpression(name: name, type: type)
    }

    private func bindParenthesizedExpression(syntax: ParenthesizedExpressionSyntax) -> BoundExpression {
        bindExpression(syntax: syntax.expression)
    }

    private func bindUnaryExpression(syntax: UnaryExpressionSyntax) -> BoundExpression {
        let boundOperand = bindExpression(syntax: syntax.operand)

        guard let boundOperator = BoundUnaryOperator.bind(
                syntaxKind: syntax.operatorToken.kind,
                operandType: boundOperand.type
        ) else {
            diagnostics.reportUndefinedUnaryOperator(span: syntax.operatorToken.span, text: syntax.operatorToken.text, type: boundOperand.type)

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
            diagnostics.reportUndefinedBinaryOperator(span: syntax.operatorToken.span, text: syntax.operatorToken.text, leftType: boundLeft.type, rightType: boundRight.type)

            return boundLeft
        }

        return BoundBinaryExpression(left: boundLeft, op: boundOperator, right: boundRight)
    }

    private func bindLiteralExpression(syntax: LiteralExpressionSyntax) -> BoundExpression {
        let value = syntax.value ?? 0

        return BoundLiteralExpression(value: value)
    }
}
