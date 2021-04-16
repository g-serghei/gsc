//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

enum SyntaxKind {
    case numberToken
    case whitespaceToken
    case plusToken
    case minusToken
    case startToken
    case slashToken
    case openParenthesisToken
    case closeParenthesisToken
    case badToken
    case endOfFileToken

    case numberExpression
    case binaryExpression
    case parenthesizedExpression
}
