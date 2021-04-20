//
// Created by Serghei Grigoruta on 17.04.2021.
//

class ParenthesizedExpressionSyntax: ExpressionSyntax {
    public var openParenthesisToken: SyntaxToken
    public var expression: ExpressionSyntax
    public var closeParenthesisToken: SyntaxToken

    override var kind: SyntaxKind {
        .parenthesizedExpression
    }

    init(openParenthesisToken: SyntaxToken, expression: ExpressionSyntax, closeParenthesisToken: SyntaxToken) {
        self.openParenthesisToken = openParenthesisToken
        self.expression = expression
        self.closeParenthesisToken = closeParenthesisToken
    }

    override func getChildren() -> [SyntaxNode] {
        [openParenthesisToken, expression, closeParenthesisToken]
    }
}
