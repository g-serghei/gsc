//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class ParenthesizedExpressionToken: SyntaxNode {
    public var openParenthesisToken: SyntaxToken
    public var expression: SyntaxNode
    public var closeParenthesisToken: SyntaxToken

    var kind: SyntaxKind {
        get {
            .parenthesizedExpression
        }
    }

    init(openParenthesisToken: SyntaxToken, expression: SyntaxNode, closeParenthesisToken: SyntaxToken) {
        self.openParenthesisToken = openParenthesisToken
        self.expression = expression
        self.closeParenthesisToken = closeParenthesisToken
    }

    func getChildren() -> [SyntaxNode] {
        [openParenthesisToken, expression, closeParenthesisToken]
    }
}
