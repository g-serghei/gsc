//
// Created by Serghei Grigoruta on 17.04.2021.
//

class UnaryExpressionSyntax: ExpressionSyntax {
    public var operatorToken: SyntaxToken
    public var operand: ExpressionSyntax

    override var kind: SyntaxKind {
        get {
            .unaryExpression
        }
    }

    init(operatorToken: SyntaxToken, operand: ExpressionSyntax) {
        self.operatorToken = operatorToken
        self.operand = operand
    }

    override func getChildren() -> [SyntaxNode] {
        [operatorToken, operand]
    }
}
