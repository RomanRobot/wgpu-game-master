from memory import UnsafePointer
from collections.string import StringSlice

import . _cffi as _c

struct Buffer:
    var _handle: _c.WGPUBuffer
    var size: UInt

    fn __init__(out self, device: Device, label: StringLiteral, usage: BufferUsage, size: UInt, mapped_at_creation: Bool):
        self._handle = _c.device_create_buffer(
            device._handle,
            _c.WGPUBufferDescriptor(
                label=label.unsafe_cstr_ptr(),
                usage=usage,
                size=size,
                mapped_at_creation=mapped_at_creation,
            ),
        )
        self.size = size

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     self.size = rhs.size
    #     rhs._handle = _c.WGPUBuffer()
    #     rhs.size = 0

    fn __del__(owned self):
        if self._handle:
            _c.buffer_release(self._handle)

    fn map_async(
        self,
        mode: MapMode,
        callback: fn (BufferMapAsyncStatus, UnsafePointer[NoneType]) -> None,
        user_data: UnsafePointer[NoneType],
    ) -> None:
        """
        TODO
        """
        _c.buffer_map_async(
            self._handle,
            mode,
            0,
            self.size,
            callback,
            user_data
        )
    
    fn map_async(
        self,
        mode: MapMode,
        offset: UInt,
        size: UInt,
        callback: fn (BufferMapAsyncStatus, UnsafePointer[NoneType]) -> None,
        user_data: UnsafePointer[NoneType],
    ) -> None:
        """
        TODO
        """
        _c.buffer_map_async(
            self._handle,
            mode,
            offset,
            size,
            callback,
            user_data
        )

    fn get_mapped_range(
        self
    ) -> UnsafePointer[NoneType]:
        """
        TODO
        """
        return self.get_mapped_range(
            0,
            self.size
        )

    fn get_mapped_range(
        self,
        offset: UInt,
        size: UInt
    ) -> UnsafePointer[NoneType]:
        """
        TODO
        """
        return _c.buffer_get_mapped_range(
            self._handle,
            offset,
            size
        )

    # fn buffer_get_const_mapped_range(
    #     handle: WGPUBuffer, offset: UInt, size: UInt
    # ) -> UnsafePointer[NoneType]:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPUBuffer, UInt, UInt) -> UnsafePointer[NoneType]
    #     ]("wgpuBufferGetConstMappedRange")(handle, offset, size)

    fn set_label(self, label: StringSlice):
        """
        TODO
        """
        _c.buffer_set_label(self._handle, label.unsafe_ptr().bitcast[Int8]())

    fn get_usage(self) -> BufferUsage:
        """
        TODO
        """
        return _c.buffer_get_usage(self._handle)

    fn get_size(self) -> UInt64:
        """
        TODO
        """
        return _c.buffer_get_size(self._handle)

    fn get_map_state(self) -> BufferMapState:
        """
        TODO
        """
        return _c.buffer_get_map_state(self._handle)

    fn unmap(self):
        """
        TODO
        """
        _c.buffer_unmap(self._handle)

    fn destroy(self):
        """
        TODO
        """
        _c.buffer_destroy(self._handle)