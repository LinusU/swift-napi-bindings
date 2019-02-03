import NAPIC

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
