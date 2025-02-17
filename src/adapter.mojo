from memory import UnsafePointer
from collections.string import StringSlice

import . _cffi as _c

from .structs import Limits, QueueDescriptor
from .instance import Instance

struct Adapter:
    var _handle: _c.WGPUAdapter

    fn __init__(
        out self,
        instance: Instance,
        opts: _c.WGPURequestAdapterOptions = _c.WGPURequestAdapterOptions(),
    ) raises:
        adapter_user_data = (_c.WGPUAdapter(), False)

        fn _req_adapter(
            status: RequestAdapterStatus,
            adapter: _c.WGPUAdapter,
            message: UnsafePointer[Int8],
            user_data: UnsafePointer[NoneType],
        ):
            u_data = user_data.bitcast[Tuple[_c.WGPUAdapter, Bool]]()
            u_data[][0] = adapter
            u_data[][1] = True

        _c.instance_request_adapter(
            instance._handle,
            _req_adapter,
            UnsafePointer.address_of(adapter_user_data).bitcast[NoneType](),
            opts,
        )
        debug_assert(adapter_user_data[1], "adapter request did not finish")
        self._handle = adapter_user_data[0]
        if not self._handle:
            raise Error("failed to get adapter.")

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUAdapter()

    fn __del__(owned self):
        if self._handle:
            _c.adapter_release(self._handle)

    # fn limits(self) -> Limits:
    #     pass

    # fn adapter_get_limits(handle: WGPUAdapter, limits: WGPUSupportedLimits) -> Bool:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPUAdapter, UnsafePointer[WGPUSupportedLimits]) -> Bool
    #     ]("wgpuAdapterGetLimits")(handle, UnsafePointer.address_of(limits))

    fn has_feature(self, feature: FeatureName) -> Bool:
        """
        TODO
        """
        return _c.adapter_has_feature(self._handle, feature)

    # fn adapter_enumerate_features(
    #     handle: WGPUAdapter, features: FeatureName
    # ) -> UInt:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUAdapter, FeatureName) -> UInt](
    #         "wgpuAdapterEnumerateFeatures"
    #     )(handle, features)

    # fn adapter_get_info(handle: WGPUAdapter, info: WGPUAdapterInfo) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPUAdapter, UnsafePointer[WGPUAdapterInfo]) -> None
    #     ]("wgpuAdapterGetInfo")(handle, UnsafePointer.address_of(info))

    fn request_device(
        self,
        label: String = "",
        required_features: List[FeatureName] = List[FeatureName](),
        limits: Limits = Limits(),
        default_queue: QueueDescriptor = QueueDescriptor(),
    ) raises -> Device:
        """
        TODO
        """
        return Device(self, label, required_features, limits, default_queue)
