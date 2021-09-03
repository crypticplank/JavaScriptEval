import XCTest
@testable import JavaScriptEval

final class JavaScriptEvalTests: XCTestCase {
    let Eval = JavaScriptEval.self
    
    let script = """
    function main(args) {
        print("Hello World!")
        testSwiftMethod(5)
        print()
        print(integer)
        integer++
        return "It works :)"
    }
    """

    let testSwiftMethod: @convention(block) (Int) -> () = { int in
        print("Running swift method in JS")
        for i in 0...int {
            print(i, terminator: "")
        }
    }
    
    let integer = 69
    
    func testEval() {
        print(JavaScriptEval.Eval(script, [Eval.Object(testSwiftMethod, "testSwiftMethod"), Eval.Object(integer, "integer")]))
        print(integer)
    }
}
