//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class LiteralExpressionSyntax: SyntaxNode {
    public var literalToken: SyntaxToken

    var kind: SyntaxKind {
        get {
            .literalExpression
        }
    }

    init(literalToken: SyntaxToken) {
        self.literalToken = literalToken
    }

    func getChildren() -> [SyntaxNode] {
        [literalToken]
    }
}
