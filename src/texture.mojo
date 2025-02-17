import . _cffi as _c

from .structs import TextureDescriptor, TextureViewDescriptor
from .texture_view import TextureView

struct Texture:
    var _handle: _c.WGPUTexture

    fn __init__(out self, device: Device, descriptor: TextureDescriptor):
        self._handle = _c.device_create_texture(
            device._handle,
            _c.WGPUTextureDescriptor(
                label=descriptor.label.unsafe_cstr_ptr(),
                usage=descriptor.usage,
                dimension=descriptor.dimension,
                size=descriptor.size,
                format=descriptor.format,
                mip_level_count=descriptor.mip_level_count,
                sample_count=descriptor.sample_count,
                view_format_count=len(descriptor.view_formats),
                view_formats=descriptor.view_formats.unsafe_ptr(),
            ),
        )

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUTexture()

    fn __del__(owned self):
        if self._handle:
            _c.texture_release(self._handle)

    fn create_view(
        self,
        descriptor: TextureViewDescriptor
    ) -> TextureView:
        """
        TODO
        """
        return TextureView(
            self,
            descriptor,
        )

    # fn texture_set_label(handle: WGPUTexture, label: UnsafePointer[Int8]) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUTexture, UnsafePointer[Int8]) -> None](
    #         "wgpuTextureSetLabel"
    #     )(handle, label)

    # fn texture_get_width(
    #     handle: WGPUTexture,
    # ) -> UInt32:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUTexture,) -> UInt32](
    #         "wgpuTextureGetWidth"
    #     )(
    #         handle,
    #     )

    # fn texture_get_height(
    #     handle: WGPUTexture,
    # ) -> UInt32:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUTexture,) -> UInt32](
    #         "wgpuTextureGetHeight"
    #     )(
    #         handle,
    #     )

    # fn texture_get_depth_or_array_layers(
    #     handle: WGPUTexture,
    # ) -> UInt32:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUTexture,) -> UInt32](
    #         "wgpuTextureGetDepthOrArrayLayers"
    #     )(
    #         handle,
    #     )

    # fn texture_get_mip_level_count(
    #     handle: WGPUTexture,
    # ) -> UInt32:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUTexture,) -> UInt32](
    #         "wgpuTextureGetMipLevelCount"
    #     )(
    #         handle,
    #     )

    # fn texture_get_sample_count(
    #     handle: WGPUTexture,
    # ) -> UInt32:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUTexture,) -> UInt32](
    #         "wgpuTextureGetSampleCount"
    #     )(
    #         handle,
    #     )

    # fn texture_get_dimension(
    #     handle: WGPUTexture,
    # ) -> TextureDimension:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[fn (WGPUTexture,) -> TextureDimension](
    #         "wgpuTextureGetDimension"
    #     )(
    #         handle,
    #     )

    fn get_format(self) -> TextureFormat:
        """
        TODO
        """
        return _c.texture_get_format(self._handle)


# fn texture_get_usage(
#     handle: WGPUTexture,
# ) -> TextureUsage:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUTexture,) -> TextureUsage](
#         "wgpuTextureGetUsage"
#     )(
#         handle,
#     )


# fn texture_destroy(
#     handle: WGPUTexture,
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUTexture,) -> None]("wgpuTextureDestroy")(
#         handle,
#     )
