//
// Created by Serghei Grigoruta on 17.04.2021.
//

enum SyntaxKind {
    case defaultKind

    // Tokens
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
    case identifierToken

    // Keywords
    case trueKeyword
    case falseKeyword

    // Expressions
    case literalExpression
    case binaryExpression
    case parenthesizedExpression
    case unaryExpression

    func getUnaryOperatorPrecedence() -> Int {
        switch self {
        case .plusToken, .minusToken:
            return 3
        default:
            return 0
        }
    }

    func getBinaryOperatorPrecedence() -> Int {
        switch self {
        case .startToken, .slashToken:
            return 2
        case .plusToken, .minusToken:
            return 1
        default:
            return 0
        }
    }
}
