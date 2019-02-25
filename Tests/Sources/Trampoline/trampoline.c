#include <NAPI.h>

napi_value _init_napi_tests(napi_env, napi_value);

NAPI_MODULE(napi_tests, _init_napi_tests)
