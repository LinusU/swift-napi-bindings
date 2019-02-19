import Foundation
import NAPIC

fileprivate func setTimeout(_ env: napi_env, _ fn: Function, _ ms: Double) throws {
    var status: napi_status!

    var global: napi_value!
    status = napi_get_global(env, &global)
    guard status == napi_ok else { throw NAPI.Error(status) }

    var setTimeout: napi_value!
    status = napi_get_named_property(env, global, "setTimeout", &setTimeout)
    guard status == napi_ok else { throw NAPI.Error(status) }

    try Function(env, from: setTimeout).call(env, fn, ms)
}

public class RunLoop {
    private static var refCount = 0
    private static var scheduled = false

    private static func tick(_ env: napi_env) throws {
        guard RunLoop.refCount > 0 else {
            RunLoop.scheduled = false
            return
        }

        CFRunLoopRunInMode(.defaultMode, 0.02, false)
        try setTimeout(env, Function(named: "tick", RunLoop.tick), 0)
    }

    public static func ref(_ env: napi_env) throws {
        RunLoop.refCount += 1

        if RunLoop.scheduled == false {
            RunLoop.scheduled = true
            try setTimeout(env, Function(named: "tick", RunLoop.tick), 0)
        }
    }

    public static func unref() {
        RunLoop.refCount -= 1
    }
}
