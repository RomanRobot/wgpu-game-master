from memory import UnsafePointer
from collections.string import StringSlice

import . _cffi as _c

struct ShaderModule:
    var _handle: _c.WGPUShaderModule

    fn __init__(
        out self, device: Device, code: StringSlice
    ) raises:
        """
        TODO
        """

        wgsl_shader = _c.WGPUShaderModuleWgslDescriptor(
            chain=_c.ChainedStruct(s_type=SType.shader_module_wgsl_descriptor),
            code=code.unsafe_ptr().bitcast[Int8](),
        )
        self._handle = _c.device_create_shader_module(
            device._handle,
            _c.WGPUShaderModuleDescriptor(
                next_in_chain=UnsafePointer.address_of(wgsl_shader).bitcast[
                    _c.ChainedStruct
                ]()
            ),
        )
        _ = wgsl_shader^
        if not self._handle:
            raise Error("failed to create shader module.")

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUShaderModule()

    fn __del__(owned self):
        if self._handle:
            _c.shader_module_release(self._handle)


# fn shader_module_get_compilation_info(
#     handle: WGPUShaderModule,
#     callback: fn (
#         CompilationInfoRequestStatus,
#         UnsafePointer[WGPUCompilationInfo],
#         UnsafePointer[NoneType],
#     ) -> None,
#     user_data: UnsafePointer[NoneType],
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (
#             WGPUShaderModule,
#             fn (
#                 CompilationInfoRequestStatus,
#                 UnsafePointer[WGPUCompilationInfo],
#                 UnsafePointer[NoneType],
#             ) -> None,
#             UnsafePointer[NoneType],
#         ) -> None
#     ]("wgpuShaderModuleGetCompilationInfo")(handle, callback, user_data)


# fn shader_module_set_label(
#     handle: WGPUShaderModule, label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUShaderModule, UnsafePointer[Int8]) -> None
#     ]("wgpuShaderModuleSetLabel")(handle, label)
