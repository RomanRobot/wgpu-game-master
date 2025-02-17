from memory import UnsafePointer
import sys

import . _cffi as _c

from .adapter import Adapter
from .structs import SurfaceCapabilities
from .texture import Texture

alias SurfaceTexture = _c.WGPUSurfaceTexture

struct Surface[window: ImmutableOrigin]:
    var _handle: _c.WGPUSurface

    fn __init__(out self, instance: Instance, window: UnsafePointer[NoneType]):
        # TODO: Handle other platforms
        objc = sys.ffi.DLHandle("libobjc.A.dylib")

        fn sel(name: String) -> UnsafePointer[NoneType]:
            return objc.get_function[
                fn (UnsafePointer[Int8]) -> UnsafePointer[NoneType]
            ]("sel_registerName")(name.unsafe_cstr_ptr())

        fn get_class(name: String) -> UnsafePointer[NoneType]:
            return objc.get_function[
                fn (UnsafePointer[Int8]) -> UnsafePointer[NoneType]
            ]("objc_getClass")(name.unsafe_cstr_ptr())

        objc_msg_send = objc.get_function[
            fn (
                UnsafePointer[NoneType], UnsafePointer[NoneType]
            ) -> UnsafePointer[NoneType]
        ]("objc_msgSend")
        objc_msg_send_bool = objc.get_function[
            fn (UnsafePointer[NoneType], UnsafePointer[NoneType], Bool) -> None
        ]("objc_msgSend")

        objc_msg_send_ptr = objc.get_function[
            fn (
                UnsafePointer[NoneType],
                UnsafePointer[NoneType],
                UnsafePointer[NoneType],
            ) -> None
        ]("objc_msgSend")

        cls = get_class("CAMetalLayer")
        metal_layer = objc_msg_send(cls, sel("layer"))
        getter = sel("contentView")
        content_view = objc_msg_send(window, getter)
        set_wants_layer = sel("setWantsLayer:")
        set_layer = sel("setLayer:")
        objc_msg_send_bool(content_view, set_wants_layer, True)
        objc_msg_send_ptr(content_view, set_layer, metal_layer)
        from_metal_layer = _cffi.WGPUSurfaceDescriptorFromMetalLayer(
            chain=_cffi.ChainedStruct(
                s_type=SType.surface_descriptor_from_metal_layer,
            ),
            layer=metal_layer,
        )
        descriptor = _cffi.WGPUSurfaceDescriptor(
            next_in_chain=UnsafePointer.address_of(from_metal_layer).bitcast[
                _cffi.ChainedStruct
            ](),
            label=UnsafePointer[Int8](),
        )
        self._handle = _c.instance_create_surface(instance._handle, descriptor)
        _ = from_metal_layer^  # keep layer alive

    fn __moveinit__(mut self, owned rhs: Self):
        self._handle = rhs._handle
        rhs._handle = _c.WGPUSurface()

    fn __del__(owned self):
        if self._handle:
            _c.surface_release(self._handle)

    fn configure(
        self,
        device: Device,
        format: TextureFormat,
        usage: TextureUsage,
        width: UInt32,
        height: UInt32,
        view_formats: List[TextureFormat] = List[TextureFormat](),
        alpha_mode: CompositeAlphaMode = enums.CompositeAlphaMode.auto,
        present_mode: PresentMode = PresentMode.fifo,
    ):
        """
        TODO
        """
        _c.surface_configure(
            self._handle,
            _c.WGPUSurfaceConfiguration(
                device=device._handle,
                format=format,
                usage=usage,
                view_format_count=len(view_formats),
                view_formats=view_formats.unsafe_ptr(),
                alpha_mode=alpha_mode,
                width=width,
                height=height,
                present_mode=present_mode,
            ),
        )

    fn get_capabilities(
        self,
        adapter: Adapter,
    ) -> SurfaceCapabilities:
        """
        TODO
        """
        return SurfaceCapabilities(self, adapter)

    #     return _wgpu.get_function[
    #         fn (
    #             WGPUSurface, WGPUAdapter, UnsafePointer[WGPUSurfaceCapabilities]
    #         ) -> None
    #     ]("wgpuSurfaceGetCapabilities")(
    #         handle, adapter, UnsafePointer.address_of(capabilities)
    #     )

    fn get_current_texture(self) -> SurfaceTexture:
        """
        TODO
        """
        tex = _c.WGPUSurfaceTexture()
        _c.surface_get_current_texture(self._handle, tex)
        return tex

    fn present(self):
        """
        TODO
        """
        _c.surface_present(self._handle)

    fn surface_unconfigure(self) -> None:
        """
        TODO
        """
        _c.surface_unconfigure(self._handle)


# fn surface_set_label(handle: WGPUSurface, label: UnsafePointer[Int8]) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUSurface, UnsafePointer[Int8]) -> None](
#         "wgpuSurfaceSetLabel"
#     )(handle, label)
