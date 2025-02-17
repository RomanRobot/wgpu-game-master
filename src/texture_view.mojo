import . _cffi as _c

from .structs import TextureViewDescriptor
from .texture import Texture
from .surface import SurfaceTexture

struct TextureView:
    var _handle: _c.WGPUTextureView

    fn __init__(
        out self,
        texture: Texture,
        descriptor: TextureViewDescriptor,
    ):
        self._handle = _c.texture_create_view(
            texture._handle,
            _c.WGPUTextureViewDescriptor(
                label=descriptor.label.unsafe_cstr_ptr(),
                format=descriptor.format,
                dimension=descriptor.dimension,
                base_mip_level=descriptor.base_mip_level,
                mip_level_count=descriptor.mip_level_count,
                base_array_layer=descriptor.base_array_layer,
                array_layer_count=descriptor.array_layer_count,
                aspect=descriptor.aspect,
            ),
        )

    fn __init__(
        out self,
        surface_texture: SurfaceTexture,
        descriptor: TextureViewDescriptor,
    ):
        self._handle = _c.texture_create_view(
            surface_texture.texture,
            _c.WGPUTextureViewDescriptor(
                label=descriptor.label.unsafe_cstr_ptr(),
                format=descriptor.format,
                dimension=descriptor.dimension,
                base_mip_level=descriptor.base_mip_level,
                mip_level_count=descriptor.mip_level_count,
                base_array_layer=descriptor.base_array_layer,
                array_layer_count=descriptor.array_layer_count,
                aspect=descriptor.aspect,
            ),
        )

    fn __moveinit__(mut self, owned rhs: Self):
        self._handle = rhs._handle
        rhs._handle = _c.WGPUTextureView()

    fn __del__(owned self):
        if self._handle:
            _c.texture_view_release(self._handle)


# fn texture_view_release(handle: WGPUTextureView):
#     _wgpu.get_function[fn (UnsafePointer[_TextureViewImpl]) -> None](
#         "wgpuTextureViewRelease"
#     )(handle)


# fn texture_view_set_label(
#     handle: WGPUTextureView, label: UnsafePointer[Int8]
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUTextureView, UnsafePointer[Int8]) -> None
#     ]("wgpuTextureViewSetLabel")(handle, label)
