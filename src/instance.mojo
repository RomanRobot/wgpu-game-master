from memory import Span, UnsafePointer

import . _cffi as _c

from .adapter import Adapter
from .surface import Surface

struct Instance:
    var _handle: _c.WGPUInstance

    fn __init__(out self) raises:
        self._handle = _c.create_instance()
        if not self._handle:
            raise Error("failed to create instance.")

    fn __moveinit__(mut self, owned rhs: Self):
        self._handle = rhs._handle
        rhs._handle = _c.WGPUInstance()

    fn __del__(owned self):
        if self._handle:
            _c.instance_release(self._handle)

    fn has_wgsl_language_feature(self, feature: WgslFeatureName) -> Bool:
        """
        TODO
        """
        return _c.instance_has_WGSL_language_feature(self._handle, feature)

    fn process_events(self):
        _c.instance_process_events(self._handle)

    fn request_adapter_sync(
        self,
        power_preference: PowerPreference = PowerPreference.undefined,
        force_fallback_adapter: Bool = False,
    ) raises -> Adapter:
        return Adapter(self)

    fn request_adapter_sync(
        self,
        surface: Surface,
        power_preference: PowerPreference = PowerPreference.undefined,
        force_fallback_adapter: Bool = False,
    ) raises -> Adapter:
        return Adapter(self, _c.WGPURequestAdapterOptions(compatible_surface=surface._handle))

    fn generate_report(self) -> _c.WGPUGlobalReport:
        report = _c.WGPUGlobalReport()
        _c.generate_report(self._handle, report)
        return report

    fn enumerate_adapters(self) -> Span[_c.WGPUAdapter, __origin_of(self)]:
        ptr = UnsafePointer[_c.WGPUAdapter]()
        len = _c.instance_enumerate_adapters(
            self._handle, _c.WGPUInstanceEnumerateAdapterOptions(), ptr
        )
        return Span[_c.WGPUAdapter, __origin_of(self)](ptr=ptr, length=len)
    
    
    