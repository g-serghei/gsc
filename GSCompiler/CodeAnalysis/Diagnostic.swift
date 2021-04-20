//
// Created by Serghei Grigoruta on 20.04.2021.
//

class Diagnostic: CustomStringConvertible {
    public var span: TextSpan
    public var message: String

    init(span: TextSpan, message: String) {
        self.span = span
        self.message = message
    }

    public var description: String {
        message
    }
}