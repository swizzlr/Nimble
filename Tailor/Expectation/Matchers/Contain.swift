import Foundation

struct _ContainMatcher<S where S: Sequence, S.GeneratorType.Element: Equatable>: Matcher {
    let expectedItem: S.GeneratorType.Element

    func matches(actualExpression: Expression<S>) -> (pass: Bool, postfix: String)  {
        let actual = actualExpression.evaluate()
        let pass = contains(actual, expectedItem)
        return (pass, "contain <\(expectedItem)>")
    }
}

struct _ContainSubstring: Matcher {
    let substring: String

    func matches(actualExpression: Expression<String>) -> (pass: Bool, postfix: String) {
        let actual = actualExpression.evaluate()
        let pass = actual.rangeOfString(substring).getLogicValue()
        return (pass, "contain <\(substring)>")
    }
}

struct _ContainerMatcher: Matcher {
    let item: AnyObject?

    func matches(actualExpression: Expression<TSContainer>) -> (pass: Bool, postfix: String) {
        let actual = actualExpression.evaluate()
        let pass = actual.containsObject(item)
        return (pass, "contain <\(item)>")
    }
}

func contain(item: AnyObject?) -> _ContainerMatcher {
    return _ContainerMatcher(item: item)
}

func contain<T: Equatable>(item: T) -> _ContainMatcher<T[]> {
    return _ContainMatcher(expectedItem: item)
}

func contain(item: String) -> _ContainSubstring {
    return _ContainSubstring(substring: item)
}