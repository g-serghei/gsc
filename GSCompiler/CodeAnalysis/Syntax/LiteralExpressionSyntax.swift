//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class LiteralExpressionSyntax: ExpressionSyntax {
    public var literalToken: SyntaxToken
    public var value: Any?

    override var kind: SyntaxKind {
        get {
            .literalExpression
        }
    }

    init(literalToken: SyntaxToken, value: Any? = nil) {
        self.literalToken = literalToken
        self.value = value ?? literalToken.value
    }

    override func getChildren() -> [SyntaxNode] {
        [literalToken]
    }
}
