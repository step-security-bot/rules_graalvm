"Rules for building native binaries using the GraalVM `native-image` tool."

load(
    "//internal/native_image:rules.bzl",
    _BAZEL_CPP_TOOLCHAIN_TYPE = "BAZEL_CPP_TOOLCHAIN_TYPE",
    _BAZEL_CURRENT_CPP_TOOLCHAIN = "BAZEL_CURRENT_CPP_TOOLCHAIN",
    _NATIVE_IMAGE_TOOLCHAIN_TYPE = "NATIVE_IMAGE_TOOLCHAIN_TYPE",
    _graal_binary_implementation = "graal_binary_implementation",
)

_native_image = rule(
    implementation = _graal_binary_implementation,
    attrs = {
        "deps": attr.label_list(providers = [[JavaInfo]]),
        "reflection_configuration": attr.label(mandatory = False, allow_single_file = True),
        "jni_configuration": attr.label(mandatory = False, allow_single_file = True),
        "main_class": attr.string(),
        "include_resources": attr.string(),
        "initialize_at_build_time": attr.string_list(),
        "initialize_at_run_time": attr.string_list(),
        "native_features": attr.string_list(),
        "native_image_tool": attr.label(
            cfg = "exec",
            allow_files = True,
            executable = True,
            mandatory = False,
        ),
        "_cc_toolchain": attr.label(
            default = Label(_BAZEL_CURRENT_CPP_TOOLCHAIN),
        ),
        "_legacy_rule": attr.bool(
            default = False,
        ),
        "check_toolchains": attr.bool(default = False),
        "data": attr.label_list(allow_files = True),
        "extra_args": attr.string_list(),
        "c_compiler_option": attr.string_list(),
    },
    executable = True,
    fragments = [
        "cpp",
        "java",
        "platform",
    ],
    toolchains = [
        config_common.toolchain_type(_BAZEL_CPP_TOOLCHAIN_TYPE, mandatory = True),
        config_common.toolchain_type(_NATIVE_IMAGE_TOOLCHAIN_TYPE, mandatory = False),
    ],
)

## Exports.
native_image = _native_image
