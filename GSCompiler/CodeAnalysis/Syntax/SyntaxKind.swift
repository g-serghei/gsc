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
    case equalsToken
    case ampersandAmpersandToken
    case pipePipeToken
    case equalsEqualsToken
    case bangEqualsToken

    // Keywords
    case trueKeyword
    case falseKeyword

    // Expressions
    case literalExpression
    case binaryExpression
    case parenthesizedExpression
    case unaryExpression
    case nameExpression
    case assignmentExpression

    func getUnaryOperatorPrecedence() -> Int {
        switch self {
        case .plusToken, .minusToken, .bangToken:
            return 6
        default:
            return 0
        }
    }

    func getBinaryOperatorPrecedence() -> Int {
        switch self {
        case .startToken, .slashToken:
            return 5
        case .plusToken, .minusToken:
            return 4
        case .equalsEqualsToken, .bangEqualsToken:
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
