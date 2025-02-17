from memory import UnsafePointer

import . _cffi as _c

struct RenderPipeline:
    var _handle: _c.WGPURenderPipeline

    fn __init__(
        out self,
        device: Device, descriptor: RenderPipelineDescriptor
    ):
        """
        TODO
        """
        v_buf_len = len(descriptor.vertex.buffers)
        buffers = List[_c.WGPUVertexBufferLayout]()
        for buf in descriptor.vertex.buffers:
            buffers.append(
                _c.WGPUVertexBufferLayout(
                    array_stride=buf[].array_stride,
                    step_mode=buf[].step_mode,
                    attribute_count=len(buf[].attributes),
                    attributes=buf[].attributes.unsafe_ptr(),
                )
            )
        frag = _c.WGPUFragmentState()
        targets = List[_c.WGPUColorTargetState]()
        if descriptor.fragment:
            for target in descriptor.fragment.value().targets:
                blend = UnsafePointer.address_of(target[].blend.value())
                targets.append(
                    _c.WGPUColorTargetState(
                        format=target[].format,
                        blend=blend,
                        write_mask=target[].write_mask,
                    )
                )
            frag = _c.WGPUFragmentState(
                module=descriptor.fragment.value().module[]._handle,
                entry_point=descriptor.fragment.value()
                .entry_point.unsafe_ptr()
                .bitcast[Int8](),
                target_count=len(targets),
                targets=targets.unsafe_ptr(),
            )

        self._handle = _c.device_create_render_pipeline(
            device._handle,
            _c.WGPURenderPipelineDescriptor(
                label=descriptor.label.unsafe_cstr_ptr(),
                vertex=_c.WGPUVertexState(
                    module=descriptor.vertex.module[]._handle,
                    entry_point=descriptor.vertex.entry_point.unsafe_ptr().bitcast[
                        Int8
                    ](),
                    buffer_count=len(buffers),
                    buffers=buffers.unsafe_ptr(),
                ),
                layout=descriptor.layout,
                depth_stencil=UnsafePointer[_c.WGPUDepthStencilState](),
                multisample=_c.WGPUMultisampleState(count=1, mask=0xFFFFFFFF),
                primitive=_c.WGPUPrimitiveState(
                    topology=descriptor.primitive.topology,
                    strip_index_format=descriptor.primitive.strip_index_format,
                    front_face=descriptor.primitive.front_face,
                    cull_mode=descriptor.primitive.cull_mode,
                ),
                fragment=UnsafePointer.address_of(frag),
            ),
        )
        _ = buffers^
        _ = frag^
        _ = targets^

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPURenderPipeline()

    fn __del__(owned self):
        if self._handle:
            _c.render_pipeline_release(self._handle)

# fn render_pipeline_release(handle: WGPURenderPipeline):
#     _wgpu.get_function[fn (UnsafePointer[_RenderPipelineImpl]) -> None](
#         "wgpuRenderPipelineRelease"
#     )(handle)


# fn render_pipeline_get_bind_group_layout(
#     handle: WGPURenderPipeline, group_index: UInt32
# ) -> WGPUBindGroupLayout:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPURenderPipeline, UInt32) -> WGPUBindGroupLayout
#     ]("wgpuRenderPipelineGetBindGroupLayout")(handle, group_index)


# fn render_pipeline_set_label(
#     handle: WGPURenderPipeline, label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPURenderPipeline, UnsafePointer[Int8]) -> None
#     ]("wgpuRenderPipelineSetLabel")(handle, label)
