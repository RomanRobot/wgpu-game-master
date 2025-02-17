import . _cffi as _c

from .structs import QuerySetDescriptor

struct QuerySet:
    var _handle: _c.WGPUQuerySet

    fn __init__(out self, device: Device, descriptor: QuerySetDescriptor):
        self._handle = _c.device_create_query_set(
            device._handle,
            _c.WGPUQuerySetDescriptor(
                label=descriptor.label.unsafe_cstr_ptr(),
                type=descriptor.type,
                count=descriptor.count,
            ),
        )

    fn __moveinit__(mut self, owned rhs: Self):
        self._handle = rhs._handle
        rhs._handle = _c.WGPUQuerySet()

    fn __del__(owned self):
        if self._handle:
            _c.query_set_release(self._handle)


# fn query_set_set_label(
#     handle: WGPUQuerySet, label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUQuerySet, UnsafePointer[Int8]) -> None](
#         "wgpuQuerySetSetLabel"
#     )(handle, label)


# fn query_set_get_type(
#     handle: WGPUQuerySet,
# ) -> QueryType:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUQuerySet,) -> QueryType](
#         "wgpuQuerySetGetType"
#     )(
#         handle,
#     )


# fn query_set_get_count(
#     handle: WGPUQuerySet,
# ) -> UInt32:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUQuerySet,) -> UInt32](
#         "wgpuQuerySetGetCount"
#     )(
#         handle,
#     )


# fn query_set_destroy(
#     handle: WGPUQuerySet,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUQuerySet,) -> None](
#         "wgpuQuerySetDestroy"
#     )(
#         handle,
#     )