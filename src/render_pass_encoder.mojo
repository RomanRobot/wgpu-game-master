from memory import Span, UnsafePointer
from collections import Optional

import . _cffi as _c

from .structs import RenderPassDepthStencilAttachment, BindGroup
from .render_pipeline import RenderPipeline
from .buffer import Buffer
from .command_encoder import CommandEncoder

struct RenderPassEncoder:
    var _handle: _c.WGPURenderPassEncoder

    fn __init__(
        out self,
        command_encoder: CommandEncoder,
        # TODO: Multiple RenderPassColorAttachment
        color_attachment: RenderPassColorAttachment,
        # TODO: RenderPassDepthStencilAttachment
        #depth_stencil_attachment: RenderPassDepthStencilAttachment,
        label: StringLiteral = "",
    ):
        """
        TODO
        """
        # attachments = List[_c.WGPURenderPassColorAttachment](
        #     capacity=len(color_attachments)
        # )
        # for attachment in color_attachments:
        #     resolve_target_opt = attachment[].resolve_target
        #     resolve_target = (
        #         resolve_target_opt.value()[]._handle if resolve_target_opt else _c.WGPUTextureView()
        #     )
        #     attachments.append(
        #         _c.WGPURenderPassColorAttachment(
        #             view=attachment[].view[]._handle,
        #             depth_slice=attachment[].depth_slice,
        #             resolve_target=resolve_target,
        #             load_op=attachment[].load_op,
        #             store_op=attachment[].store_op,
        #             clear_value=attachment[].clear_value,
        #         )
        #     )
        c_color_attachment = _c.WGPURenderPassColorAttachment(
                    view=color_attachment.view._handle,
                    depth_slice=color_attachment.depth_slice,
                    resolve_target=_c.WGPUTextureView(),
                    load_op=color_attachment.load_op,
                    store_op=color_attachment.store_op,
                    clear_value=color_attachment.clear_value,
                )
        self._handle = _c.command_encoder_begin_render_pass(
            command_encoder._handle,
            _c.WGPURenderPassDescriptor(
                label=label.unsafe_cstr_ptr(),
                color_attachment_count=1,
                color_attachments=UnsafePointer.address_of(c_color_attachment),
            ),
        )
        _ = c_color_attachment

    fn __moveinit__(mut self, owned rhs: Self):
        self._handle = rhs._handle
        rhs._handle = _c.WGPURenderPassEncoder()

    fn __del__(owned self):
        if self._handle:
            _c.render_pass_encoder_release(self._handle)

    fn set_pipeline(self, pipeline: RenderPipeline):
        """
        TODO
        """
        _c.render_pass_encoder_set_pipeline(self._handle, pipeline._handle)

    fn set_bind_group(
        self,
        group_index: UInt32,
        dynamic_offsets_count: Int,
        dynamic_offsets: UnsafePointer[UInt32],
        group: BindGroup,
    ) -> None:
        """
        TODO
        """
        return _c.render_pass_encoder_set_bind_group(
            self._handle,
            group_index,
            dynamic_offsets_count,
            dynamic_offsets,
            group
        )


    fn draw(
        self,
        vertex_count: UInt32,
        instance_count: UInt32,
        first_vertex: UInt32,
        first_instance: UInt32,
    ):
        """
        TODO
        """
        _c.render_pass_encoder_draw(
            self._handle,
            vertex_count,
            instance_count,
            first_vertex,
            first_instance,
        )

    # fn render_pass_encoder_draw_indexed(
    #     handle: WGPURenderPassEncoder,
    #     index_count: UInt32,
    #     instance_count: UInt32,
    #     first_index: UInt32,
    #     base_vertex: Int32,
    #     first_instance: UInt32,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPURenderPassEncoder, UInt32, UInt32, UInt32, Int32, UInt32
    #         ) -> None
    #     ]("wgpuRenderPassEncoderDrawIndexed")(
    #         handle,
    #         index_count,
    #         instance_count,
    #         first_index,
    #         base_vertex,
    #         first_instance,
    #     )

    # fn render_pass_encoder_draw_indirect(
    #     handle: WGPURenderPassEncoder,
    #     indirect_buffer: WGPUBuffer,
    #     indirect_offset: UInt64,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPURenderPassEncoder, WGPUBuffer, UInt64) -> None
    #     ]("wgpuRenderPassEncoderDrawIndirect")(
    #         handle, indirect_buffer, indirect_offset
    #     )

    # fn render_pass_encoder_draw_indexed_indirect(
    #     handle: WGPURenderPassEncoder,
    #     indirect_buffer: WGPUBuffer,
    #     indirect_offset: UInt64,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPURenderPassEncoder, WGPUBuffer, UInt64) -> None
    #     ]("wgpuRenderPassEncoderDrawIndexedIndirect")(
    #         handle, indirect_buffer, indirect_offset
    #     )

    # fn render_pass_encoder_execute_bundles(
    #     handle: WGPURenderPassEncoder,
    #     bundles_count: Int,
    #     bundles: UnsafePointer[WGPURenderBundle],
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPURenderPassEncoder, Int32, UnsafePointer[WGPURenderBundle]
    #         ) -> None
    #     ]("wgpuRenderPassEncoderExecuteBundles")(handle, bundles_count, bundles)

    # fn render_pass_encoder_insert_debug_marker(
    #     handle: WGPURenderPassEncoder, marker_label: UnsafePointer[Int8]
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPURenderPassEncoder, UnsafePointer[Int8]) -> None
    #     ]("wgpuRenderPassEncoderInsertDebugMarker")(handle, marker_label)

    # fn render_pass_encoder_pop_debug_group(
    #     handle: WGPURenderPassEncoder,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPURenderPassEncoder,) -> None](
    #         "wgpuRenderPassEncoderPopDebugGroup"
    #     )(
    #         handle,
    #     )

    # fn render_pass_encoder_push_debug_group(
    #     handle: WGPURenderPassEncoder, group_label: UnsafePointer[Int8]
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPURenderPassEncoder, UnsafePointer[Int8]) -> None
    #     ]("wgpuRenderPassEncoderPushDebugGroup")(handle, group_label)

    # fn render_pass_encoder_set_stencil_reference(
    #     handle: WGPURenderPassEncoder, reference: UInt32
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPURenderPassEncoder, UInt32) -> None](
    #         "wgpuRenderPassEncoderSetStencilReference"
    #     )(handle, reference)

    # fn render_pass_encoder_set_blend_constant(
    #     handle: WGPURenderPassEncoder, color: WGPUColor
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPURenderPassEncoder, UnsafePointer[WGPUColor]) -> None
    #     ]("wgpuRenderPassEncoderSetBlendConstant")(
    #         handle, UnsafePointer.address_of(color)
    #     )

    # fn render_pass_encoder_set_viewport(
    #     handle: WGPURenderPassEncoder,
    #     x: Float32,
    #     y: Float32,
    #     width: Float32,
    #     height: Float32,
    #     min_depth: Float32,
    #     max_depth: Float32,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPURenderPassEncoder,
    #             Float32,
    #             Float32,
    #             Float32,
    #             Float32,
    #             Float32,
    #             Float32,
    #         ) -> None
    #     ]("wgpuRenderPassEncoderSetViewport")(
    #         handle, x, y, width, height, min_depth, max_depth
    #     )

    # fn render_pass_encoder_set_scissor_rect(
    #     handle: WGPURenderPassEncoder,
    #     x: UInt32,
    #     y: UInt32,
    #     width: UInt32,
    #     height: UInt32,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPURenderPassEncoder, UInt32, UInt32, UInt32, UInt32) -> None
    #     ]("wgpuRenderPassEncoderSetScissorRect")(handle, x, y, width, height)

    fn set_vertex_buffer(
        self,
        slot: UInt32,
        buffer: Buffer
    ):
        """
        TODO
        """
        _c.render_pass_encoder_set_vertex_buffer(
            self._handle,
            slot,
            0,
            buffer.size,
            buffer._handle
        )

    fn set_vertex_buffer(
        self,
        slot: UInt32,
        buffer: Buffer,
        offset: UInt64,
        size: UInt64
    ):
        """
        TODO
        """
        _c.render_pass_encoder_set_vertex_buffer(
            self._handle,
            slot,
            offset,
            size,
            buffer._handle
        )

    # fn render_pass_encoder_set_index_buffer(
    #     handle: WGPURenderPassEncoder,
    #     buffer: WGPUBuffer,
    #     format: IndexFormat,
    #     offset: UInt64,
    #     size: UInt64,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPURenderPassEncoder, WGPUBuffer, IndexFormat, UInt64, UInt64
    #         ) -> None
    #     ]("wgpuRenderPassEncoderSetIndexBuffer")(
    #         handle, buffer, format, offset, size
    #     )

    # fn render_pass_encoder_begin_occlusion_query(
    #     handle: WGPURenderPassEncoder, query_index: UInt32
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPURenderPassEncoder, UInt32) -> None](
    #         "wgpuRenderPassEncoderBeginOcclusionQuery"
    #     )(handle, query_index)

    # fn render_pass_encoder_end_occlusion_query(
    #     handle: WGPURenderPassEncoder,
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPURenderPassEncoder,) -> None](
    #         "wgpuRenderPassEncoderEndOcclusionQuery"
    #     )(
    #         handle,
    #     )

    fn end(self):
        """
        TODO
        """
        _c.render_pass_encoder_end(self._handle)


# fn render_pass_encoder_set_label(
#     handle: WGPURenderPassEncoder, label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPURenderPassEncoder, UnsafePointer[Int8]) -> None
#     ]("wgpuRenderPassEncoderSetLabel")(handle, label)