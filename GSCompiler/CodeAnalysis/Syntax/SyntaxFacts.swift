//
// Created by Serghei Grigoruta on 18.04.2021.
//

class SyntaxFacts {
    static func getKeywordKind(text: String) -> SyntaxKind {
        switch text {
        case "true":
            return .trueKeyword
        case "false":
            return .falseKeyword
        default:
            return .identifierToken
        }
    }
}