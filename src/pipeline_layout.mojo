import . _cffi as _c

# struct PipelineLayout:
#     var _handle: _c.WGPUPipelineLayout

#     fn __init__(out self, unsafe_ptr: _c.WGPUPipelineLayout):
#         self._handle = unsafe_ptr

#     fn __moveinit__(mut self, owned rhs: Self):
#         self._handle = rhs._handle
#         rhs._handle = _c.WGPUPipelineLayout()

#     fn __del__(owned self):
#         if self._handle:
#             _c.pipeline_layout_release(self._handle)
alias PipelineLayout = _c.WGPUPipelineLayout
# TODO: RAII PipelineLayout that doesn't need to be released manually.

# fn pipeline_layout_release(handle: WGPUPipelineLayout):
#     _wgpu.get_function[fn (UnsafePointer[_PipelineLayoutImpl]) -> None](
#         "wgpuPipelineLayoutRelease"
#     )(handle)


# fn pipeline_layout_set_label(
#     handle: WGPUPipelineLayout, label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUPipelineLayout, UnsafePointer[Int8]) -> None
#     ]("wgpuPipelineLayoutSetLabel")(handle, label)
