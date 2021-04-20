//
// Created by Serghei Grigoruta on 20.04.2021.
//

class Compilation {
    public var syntax: SyntaxTree

    init(syntax: SyntaxTree) {
        self.syntax = syntax
    }

    func evaluate(variables: inout Dictionary<String, Any>) -> EvaluationResult {
        let binder = Binder(variables: &variables)
        let boundExpression = binder.bindExpression(syntax: syntax.root)

        let diagnostics = syntax.diagnostics

        diagnostics.append(contentsOf: binder.diagnostics)

        if !diagnostics.isEmpty {
            return EvaluationResult(diagnostics: diagnostics, value: nil)
        }

        let evaluator = Evaluator(root: boundExpression, variables: &variables)
        let value = evaluator.evaluate()

        return EvaluationResult(diagnostics: DiagnosticBag(), value: value)
    }
}