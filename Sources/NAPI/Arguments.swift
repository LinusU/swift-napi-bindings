import NAPIC

internal typealias NullableArguments = (
    // Values
    napi_value?,
    napi_value?,
    napi_value?,
    napi_value?,
    napi_value?,
    napi_value?,
    napi_value?,
    napi_value?,
    napi_value?,
    napi_value?,

    // Number of passed arguments
    length: Int,

    // The `this` value
    this: napi_value?
)

public typealias Arguments = (
    // Values
    napi_value,
    napi_value,
    napi_value,
    napi_value,
    napi_value,
    napi_value,
    napi_value,
    napi_value,
    napi_value,
    napi_value,

    // Number of passed arguments
    length: Int,

    // The `this` value
    this: napi_value
)
