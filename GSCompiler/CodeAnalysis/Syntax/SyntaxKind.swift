//
// Created by Serghei Grigoruta on 17.04.2021.
//

enum SyntaxKind {
    case undefinedKind

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
    case bangToken
    case ampersandAmpersandToken
    case pipePipeToken

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
        case .plusToken, .minusToken, .bangToken:
            return 5
        default:
            return 0
        }
    }

    func getBinaryOperatorPrecedence() -> Int {
        switch self {
        case .startToken, .slashToken:
            return 4
        case .plusToken, .minusToken:
            return 3
        case .ampersandAmpersandToken:
            return 2
        case .pipePipeToken:
            return 1
        default:
            return 0
        }
    }
}
