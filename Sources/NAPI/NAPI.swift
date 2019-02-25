import NAPIC

public func strictlyEquals(_ env: napi_env, lhs: napi_value, rhs: napi_value) throws -> Bool {
    var isEqual = false
    let status = napi_strict_equals(env, lhs, rhs, &isEqual)
    guard status == napi_ok else { throw NAPI.Error(status) }
    return isEqual
}

public func strictlyEquals(_ env: napi_env, lhs: napi_value, rhs: ValueConvertible) throws -> Bool {
    return try strictlyEquals(env, lhs: lhs, rhs: rhs.napiValue(env))
}

public func strictlyEquals(_ env: napi_env, lhs: ValueConvertible, rhs: napi_value) throws -> Bool {
    return try strictlyEquals(env, lhs: lhs.napiValue(env), rhs: rhs)
}

public func strictlyEquals(_ env: napi_env, lhs: ValueConvertible, rhs: ValueConvertible) throws -> Bool {
    return try strictlyEquals(env, lhs: lhs.napiValue(env), rhs: rhs.napiValue(env))
}

public func defineProperties(_ env: napi_env, _ object: napi_value, _ properties: [PropertyDescriptor]) throws {
    let props = try properties.map { try $0.value(env) }

    let status = props.withUnsafeBufferPointer { propertiesBytes in
        napi_define_properties(env, object, properties.count, propertiesBytes.baseAddress)
    }

    guard status == napi_ok else { throw NAPI.Error(status) }
}

public func initModule(_ env: napi_env, _ exports: napi_value, _ properties: [PropertyDescriptor]) -> napi_value {
    try! defineProperties(env, exports, properties)
    return exports
}
