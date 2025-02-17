from memory import Span
from collections import Optional

import . _cffi as _c

from .structs import CommandBuffer, RenderPassColorAttachment, RenderPassDepthStencilAttachment
from .render_pass_encoder import RenderPassEncoder
from .buffer import Buffer

struct CommandEncoder:
    var _handle: _c.WGPUCommandEncoder

    fn __init__(out self, device: Device, label: StringLiteral = ""):
        self._handle = _c.device_create_command_encoder(
            device._handle,
            _c.WGPUCommandEncoderDescriptor(label=label.unsafe_cstr_ptr()),
        )

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUCommandEncoder()

    fn __del__(owned self):
        if self._handle:
            _c.command_encoder_release(self._handle)

    fn finish(self, label: StringLiteral = "") -> CommandBuffer:
        """
        TODO
        """
        return CommandBuffer(self, label)

    # fn command_encoder_begin_compute_pass(
    #     handle: WGPUCommandEncoder,
    #     descriptor: WGPUComputePassDescriptor = WGPUComputePassDescriptor(),
    # ) -> WGPUComputePassEncoder:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPUCommandEncoder, UnsafePointer[WGPUComputePassDescriptor]
    #         ) -> WGPUComputePassEncoder
    #     ]("wgpuCommandEncoderBeginComputePass")(
    #         handle, UnsafePointer.address_of(descriptor)
    #     )

    fn begin_render_pass(
        self,
        color_attachment: RenderPassColorAttachment,
        #depth_stencil_attachment: Optional[RenderPassDepthStencilAttachment] = None,
        label: StringLiteral = "",
    ) -> RenderPassEncoder:
        """
        TODO
        """
        return RenderPassEncoder(self, color_attachment, label)

    fn copy_buffer_to_buffer(
        self,
        source: Buffer,
        source_offset: UInt64,
        destination: Buffer,
        destination_offset: UInt64,
        size: UInt64,
    ):
        """
        TODO
        """
        _c.command_encoder_copy_buffer_to_buffer(
            self._handle,
            source._handle,
            source_offset,
            destination._handle,
            destination_offset,
            size,
        )


# fn command_encoder_copy_buffer_to_texture(
#     handle: WGPUCommandEncoder,
#     source: WGPUImageCopyBuffer,
#     destination: WGPUImageCopyTexture,
#     copy_size: WGPUExtent3D,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (
#             WGPUCommandEncoder,
#             UnsafePointer[WGPUImageCopyBuffer],
#             UnsafePointer[WGPUImageCopyTexture],
#             UnsafePointer[WGPUExtent3D],
#         ) -> None
#     ]("wgpuCommandEncoderCopyBufferToTexture")(
#         handle,
#         UnsafePointer.address_of(source),
#         UnsafePointer.address_of(destination),
#         UnsafePointer.address_of(copy_size),
#     )


# fn command_encoder_copy_texture_to_buffer(
#     handle: WGPUCommandEncoder,
#     source: WGPUImageCopyTexture,
#     destination: WGPUImageCopyBuffer,
#     copy_size: WGPUExtent3D,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (
#             WGPUCommandEncoder,
#             UnsafePointer[WGPUImageCopyTexture],
#             UnsafePointer[WGPUImageCopyBuffer],
#             UnsafePointer[WGPUExtent3D],
#         ) -> None
#     ]("wgpuCommandEncoderCopyTextureToBuffer")(
#         handle,
#         UnsafePointer.address_of(source),
#         UnsafePointer.address_of(destination),
#         UnsafePointer.address_of(copy_size),
#     )


# fn command_encoder_copy_texture_to_texture(
#     handle: WGPUCommandEncoder,
#     source: WGPUImageCopyTexture,
#     destination: WGPUImageCopyTexture,
#     copy_size: WGPUExtent3D,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (
#             WGPUCommandEncoder,
#             UnsafePointer[WGPUImageCopyTexture],
#             UnsafePointer[WGPUImageCopyTexture],
#             UnsafePointer[WGPUExtent3D],
#         ) -> None
#     ]("wgpuCommandEncoderCopyTextureToTexture")(
#         handle,
#         UnsafePointer.address_of(source),
#         UnsafePointer.address_of(destination),
#         UnsafePointer.address_of(copy_size),
#     )


# fn command_encoder_clear_buffer(
#     handle: WGPUCommandEncoder, buffer: WGPUBuffer, offset: UInt64, size: UInt64
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUCommandEncoder, WGPUBuffer, UInt64, UInt64) -> None
#     ]("wgpuCommandEncoderClearBuffer")(handle, buffer, offset, size)


# fn command_encoder_insert_debug_marker(
#     handle: WGPUCommandEncoder, marker_label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUCommandEncoder, UnsafePointer[Int8]) -> None
#     ]("wgpuCommandEncoderInsertDebugMarker")(handle, marker_label)


# fn command_encoder_pop_debug_group(
#     handle: WGPUCommandEncoder,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUCommandEncoder,) -> None](
#         "wgpuCommandEncoderPopDebugGroup"
#     )(
#         handle,
#     )


# fn command_encoder_push_debug_group(
#     handle: WGPUCommandEncoder, group_label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUCommandEncoder, UnsafePointer[Int8]) -> None
#     ]("wgpuCommandEncoderPushDebugGroup")(handle, group_label)


# fn command_encoder_resolve_query_set(
#     handle: WGPUCommandEncoder,
#     query_set: WGPUQuerySet,
#     first_query: UInt32,
#     query_count: UInt32,
#     destination: WGPUBuffer,
#     destination_offset: UInt64,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (
#             WGPUCommandEncoder, WGPUQuerySet, UInt32, UInt32, WGPUBuffer, UInt64
#         ) -> None
#     ]("wgpuCommandEncoderResolveQuerySet")(
#         handle,
#         query_set,
#         first_query,
#         query_count,
#         destination,
#         destination_offset,
#     )


# fn command_encoder_write_timestamp(
#     handle: WGPUCommandEncoder, query_set: WGPUQuerySet, query_index: UInt32
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUCommandEncoder, WGPUQuerySet, UInt32) -> None
#     ]("wgpuCommandEncoderWriteTimestamp")(handle, query_set, query_index)


# fn command_encoder_set_label(
#     handle: WGPUCommandEncoder, label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUCommandEncoder, UnsafePointer[Int8]) -> None
#     ]("wgpuCommandEncoderSetLabel")(handle, label)
