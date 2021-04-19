//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class LiteralExpressionSyntax: ExpressionSyntax {
    public var literalToken: SyntaxToken

    override var kind: SyntaxKind {
        get {
            .literalExpression
        }
    }

    init(literalToken: SyntaxToken) {
        self.literalToken = literalToken
    }

    override func getChildren() -> [SyntaxNode] {
        [literalToken]
    }
}
