//
// Created by Serghei Grigoruta on 17.04.2021.
//

class BinaryExpressionSyntax: ExpressionSyntax {
    public var left: ExpressionSyntax
    public var operatorToken: SyntaxToken
    public var right: ExpressionSyntax

    override var kind: SyntaxKind {
        get {
            .binaryExpression
        }
    }

    init(left: ExpressionSyntax, operatorToken: SyntaxToken, right: ExpressionSyntax) {
        self.left = left
        self.operatorToken = operatorToken
        self.right = right
    }

    override func getChildren() -> [SyntaxNode] {
        [left, operatorToken, right]
    }
}
