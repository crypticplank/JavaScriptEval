import JavaScriptCore

public class JavaScriptEval {
    private static let javaScriptPrint: @convention(block) (Any?, String?) -> () = { item, terminator in
        if (item != nil) {
            if terminator! == "undefined" {
                return print(item!, terminator: "\n")
            }
            return print(item!, terminator: terminator ?? "\n")
        } else {
            return print("")
        }
    }
    
    private static func javaScriptAddFunction(_ context: UnsafeMutablePointer<JSContext>, _ function: Any, _ name: String) {
        context.pointee.setObject(function, forKeyedSubscript: name as NSString)
    }
    
    public struct JavaScriptObject {
        var object: Any
        var name:   String
    }
    
    public static func Object(_ object: Any, _ name: String) -> JavaScriptEval.JavaScriptObject {
        return JavaScriptEval.JavaScriptObject(object: object, name: name)
    }
    
    public static func Eval(_ script: String, _ objects: [JavaScriptObject]? = nil, _ args: [Any]? = nil) -> Any {
        var context = JSContext()
        context?.evaluateScript(script)
        context?.setObject(javaScriptPrint, forKeyedSubscript: "print" as NSString) // Default
        let mainFunction = context?.objectForKeyedSubscript("main")
        if objects != nil {
            for object in objects! {
                javaScriptAddFunction(&context!, object.object, object.name)
            }
        }
        let ret = mainFunction!.call(withArguments: args)! as Any
        return ret
    }
}
