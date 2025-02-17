from memory import UnsafePointer

import . _cffi as _c

from .structs import CommandBuffer
from .buffer import Buffer

struct Queue:
    var _handle: _c.WGPUQueue

    fn __init__(out self, device: Device):
        self._handle = _c.device_get_queue(device._handle)

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUQueue()

    fn __del__(owned self):
        if self._handle:
            _c.queue_release(self._handle)

    fn submit(
        self,
        command: CommandBuffer,
    ) -> None:
        """
        TODO
        """
        _c.queue_submit(
            self._handle, 1, UnsafePointer.address_of(command._handle)
        )


# fn queue_on_submitted_work_done(
#     handle: WGPUQueue,
#     callback: fn (QueueWorkDoneStatus, UnsafePointer[NoneType]) -> None,
#     user_data: UnsafePointer[NoneType],
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (
#             WGPUQueue,
#             fn (QueueWorkDoneStatus, UnsafePointer[NoneType]) -> None,
#             UnsafePointer[NoneType],
#         ) -> None
#     ]("wgpuQueueOnSubmittedWorkDone")(handle, callback, user_data)


    fn write_buffer(
        self,
        buffer: Buffer,
        data: UnsafePointer[UInt8]
    ) -> None:
        """
        TODO
        """
        _c.queue_write_buffer(
            self._handle,
            buffer._handle,
            0,
            data,
            buffer.size
        )
    
    
    fn write_buffer(
        self,
        buffer: Buffer,
        buffer_offset: UInt64,
        data: UnsafePointer[UInt8],
        size: UInt
    ) -> None:
        """
        TODO
        """
        _c.queue_write_buffer(
            self._handle,
            buffer._handle,
            buffer_offset,
            data,
            size
        )


# fn queue_write_texture(
#     handle: WGPUQueue,
#     destination: WGPUImageCopyTexture,
#     data: UnsafePointer[NoneType],
#     data_size: UInt,
#     data_layout: WGPUTextureDataLayout,
#     write_size: WGPUExtent3D,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (
#             WGPUQueue,
#             UnsafePointer[WGPUImageCopyTexture],
#             UnsafePointer[NoneType],
#             UInt,
#             UnsafePointer[WGPUTextureDataLayout],
#             UnsafePointer[WGPUExtent3D],
#         ) -> None
#     ]("wgpuQueueWriteTexture")(
#         handle,
#         UnsafePointer.address_of(destination),
#         data,
#         data_size,
#         UnsafePointer.address_of(data_layout),
#         UnsafePointer.address_of(write_size),
#     )


# fn queue_set_label(handle: WGPUQueue, label: UnsafePointer[Int8]) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUQueue, UnsafePointer[Int8]) -> None](
#         "wgpuQueueSetLabel"
#     )(handle, label)
