from collections.string import StringSlice
from memory import UnsafePointer

import . _cffi as _c

from .structs import
    BindGroup,
    BindGroupLayout,
    BindGroupDescriptor,
    PipelineLayoutDescriptor,
    RenderPipelineDescriptor,
    SamplerDescriptor,
    QuerySetDescriptor,
    Sampler,
    TextureDescriptor,
    Limits,
    QueueDescriptor
from .adapter import Adapter
from .buffer import Buffer
from .command_encoder import CommandEncoder
from .pipeline_layout import PipelineLayout
from .render_pipeline import RenderPipeline
from .query_set import QuerySet
from .shader_module import ShaderModule
from .texture import Texture
from .queue import Queue

struct Device:
    var _handle: _c.WGPUDevice

    fn __init__(
        out self,
        adapter: Adapter,
        label: String = "",
        required_features: List[FeatureName] = List[FeatureName](),
        limits: Limits = Limits(),
        default_queue: QueueDescriptor = QueueDescriptor(),
    ) raises:
        """
        TODO
        """

        user_data = (_c.WGPUDevice(), False)

        fn _req(
            status: RequestDeviceStatus,
            device: _c.WGPUDevice,
            message: UnsafePointer[Int8],
            user_data: UnsafePointer[NoneType],
        ):
            u_data = user_data.bitcast[Tuple[_c.WGPUDevice, Bool]]()
            u_data[][0] = device
            u_data[][1] = True

        var lim = _c.WGPURequiredLimits(limits=limits)
        _c.adapter_request_device(
            adapter._handle,
            _req,
            UnsafePointer.address_of(user_data).bitcast[NoneType](),
            # _c.WGPUDeviceDescriptor(
            #     label=label.unsafe_cstr_ptr(),
            #     required_features_count=len(required_features),
            #     required_features=required_features.unsafe_ptr(),
            #     required_limits=UnsafePointer.address_of(lim),
            #     default_queue=_c.WGPUQueueDescriptor(
            #         label=default_queue.label.unsafe_cstr_ptr(),
            # #     ),
            # ),
        )
        _ = lim^
        self._handle = user_data[0]
        debug_assert(user_data[1], "Expected device callback to be done")

        _ = user_data^
        if not self._handle:
            raise Error("failed to get device.")

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUDevice()

    fn __del__(owned self):
        if self._handle:
            _c.device_release(self._handle)

    fn create_bind_groups(
        self,
        descriptors: List[BindGroupDescriptor]
    ) -> (List[BindGroup], List[BindGroupLayout]):
        """
        TODO
        """
        # TODO: Expose BindGroup and BindGroupLayout with RAII, not _c ones that need to be released manually.
        bind_groups = List[BindGroup]()
        layouts = List[BindGroupLayout]()
        for descriptor in descriptors:
            layout = _c.device_create_bind_group_layout(
                self._handle,
                _c.WGPUBindGroupLayoutDescriptor(
                    label=descriptor[].layout.label.unsafe_cstr_ptr(),
                    entrie_count=len(descriptor[].layout.entries),
                    entries=descriptor[].layout.entries.unsafe_ptr(),
                ),
            )
            layouts.append(layout)
            bind_groups.append(_c.device_create_bind_group(
                self._handle,
                _c.WGPUBindGroupDescriptor(
                    label=descriptor[].label.unsafe_cstr_ptr(),
                    layout=layout,
                    entrie_count=len(descriptor[].entries),
                    entries=descriptor[].entries.unsafe_ptr(),
                )
            ))
        return bind_groups, layouts


    # fn create_bind_group(self, descriptor: BindGroupDescriptor) -> BindGroup:
    #     """
    #     TODO
    #     """
    #     # entries = List[_c.WGPUBindGroupEntry]()
    #     # for entry in descriptor.entries:
    #     #     entries.append(
    #     #         _c.WGPUBindGroupEntry(
    #     #             binding=entry[].binding,
    #     #             buffer=entry[].buffer[]._handle,
    #     #             offset=entry[].offset,
    #     #             size=entry[].size,
    #     #             sampler=entry[].sampler[]._handle,
    #     #             texture_view=entry[].texture_view[]._handle,
    #     #         )
    #     #     )
    #     handle = _c.device_create_bind_group(
    #         self._handle,
    #         _c.WGPUBindGroupDescriptor(
    #             label=descriptor.label.unsafe_cstr_ptr(),
    #             layout=descriptor.layout._handle,
    #             entrie_count=len(descriptor.entries),
    #             entries=descriptor.entries.unsafe_ptr(),
    #         ),
    #     )
    #     _ = descriptor.entries
    #     return BindGroup(handle)

    # fn create_bind_group_layout(
    #     self, descriptor: BindGroupLayoutDescriptor
    # ) -> BindGroupLayout:
    #     """
    #     TODO
    #     """
    #     #entries = List[_c.WGPUBindGroupLayoutEntry]()
    #     # for entry in descriptor.entries:
    #     #     entries.append(
    #     #         # _c.WGPUBindGroupLayoutEntry(
    #     #         #     binding=entry[].binding,
    #     #         #     visibility=entry[].visibility,
    #     #         #     buffer=_c.WGPUBufferBindingLayout(
    #     #         #         # type: BufferBindingType
    #     #         #         # has_dynamic_offset: Bool
    #     #         #         # min_binding_size: UInt64
    #     #         #         type=entry[].buffer.type,),
    #     #         #     # var buffer= WGPUBufferBindingLayout
    #     #         #     # var sampler= WGPUSamplerBindingLayout
    #     #         #     # var texture= WGPUTextureBindingLayout
    #     #         #     # var storage_texture= WGPUStorageTextureBindingLayout
    #     #         # )
    #     #     )
    #     return BindGroupLayout(
    #         _c.device_create_bind_group_layout(
    #             self._handle,
    #             _c.WGPUBindGroupLayoutDescriptor(
    #                 label=descriptor.label.unsafe_cstr_ptr(),
    #                 entrie_count=len(descriptor.entries),
    #                 entries=descriptor.entries.unsafe_ptr(),
    #             ),
    #         )
    #     )

    #     return _wgpu.get_function[
    #         fn (
    #             WGPUDevice, UnsafePointer[WGPUBindGroupLayoutDescriptor]
    #         ) -> WGPUBindGroupLayout
    #     ]("wgpuDeviceCreateBindGroupLayout")(
    #         handle, UnsafePointer.address_of(descriptor)
    #     )

    fn create_buffer(self, label: StringLiteral, usage: BufferUsage, size: UInt, mapped_at_creation: Bool) -> Buffer:
        """
        TODO
        """
        return Buffer(self, label, usage, size, mapped_at_creation)

    fn create_command_encoder(
        self, label: StringLiteral = ""
    ) -> CommandEncoder:
        """
        TODO
        """
        return CommandEncoder(self, label)

    # fn device_create_compute_pipeline(
    #     handle: WGPUDevice, descriptor: WGPUComputePipelineDescriptor
    # ) -> WGPUComputePipeline:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPUDevice, UnsafePointer[WGPUComputePipelineDescriptor]
    #         ) -> WGPUComputePipeline
    #     ]("wgpuDeviceCreateComputePipeline")(
    #         handle, UnsafePointer.address_of(descriptor)
    #     )

    # fn device_create_compute_pipeline_async(
    #     handle: WGPUDevice,
    #     descriptor: WGPUComputePipelineDescriptor,
    #     callback: fn (
    #         CreatePipelineAsyncStatus,
    #         WGPUComputePipeline,
    #         UnsafePointer[Int8],
    #         UnsafePointer[NoneType],
    #     ) -> None,
    #     user_data: UnsafePointer[NoneType],
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPUDevice,
    #             UnsafePointer[WGPUComputePipelineDescriptor],
    #             fn (
    #                 CreatePipelineAsyncStatus,
    #                 WGPUComputePipeline,
    #                 UnsafePointer[Int8],
    #                 UnsafePointer[NoneType],
    #             ) -> None,
    #             UnsafePointer[NoneType],
    #         ) -> None
    #     ]("wgpuDeviceCreateComputePipelineAsync")(
    #         handle, UnsafePointer.address_of(descriptor), callback, user_data
    #     )

    fn create_pipeline_layout(
        self,
        descriptor: PipelineLayoutDescriptor
    ) -> PipelineLayout:
        """
        TODO
        """
        return PipelineLayout(
            _c.device_create_pipeline_layout(
                self._handle,
                _c.WGPUPipelineLayoutDescriptor(
                    label=descriptor.label.unsafe_cstr_ptr(),
                    bind_group_layout_count=len(descriptor.bind_group_layouts),
                    bind_group_layouts=descriptor.bind_group_layouts.unsafe_ptr()
                ),
            )
        )

    fn create_query_set(self, descriptor: QuerySetDescriptor) -> QuerySet:
        """
        TODO
        """
        return QuerySet(self, descriptor)

    # fn device_create_render_pipeline_async(
    #     handle: WGPUDevice,
    #     descriptor: WGPURenderPipelineDescriptor,
    #     callback: fn (
    #         CreatePipelineAsyncStatus,
    #         WGPURenderPipeline,
    #         UnsafePointer[Int8],
    #         UnsafePointer[NoneType],
    #     ) -> None,
    #     user_data: UnsafePointer[NoneType],
    # ) -> None:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPUDevice,
    #             UnsafePointer[WGPURenderPipelineDescriptor],
    #             fn (
    #                 CreatePipelineAsyncStatus,
    #                 WGPURenderPipeline,
    #                 UnsafePointer[Int8],
    #                 UnsafePointer[NoneType],
    #             ) -> None,
    #             UnsafePointer[NoneType],
    #         ) -> None
    #     ]("wgpuDeviceCreateRenderPipelineAsync")(
    #         handle, UnsafePointer.address_of(descriptor), callback, user_data
    #     )

    # fn device_create_render_bundle_encoder(
    #     handle: WGPUDevice, descriptor: WGPURenderBundleEncoderDescriptor
    # ) -> WGPURenderBundleEncoder:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (
    #             WGPUDevice, UnsafePointer[WGPURenderBundleEncoderDescriptor]
    #         ) -> WGPURenderBundleEncoder
    #     ]("wgpuDeviceCreateRenderBundleEncoder")(
    #         handle, UnsafePointer.address_of(descriptor)
    #     )

    fn create_render_pipeline(
        self, descriptor: RenderPipelineDescriptor
    ) -> RenderPipeline:
        """
        TODO
        """
        return RenderPipeline(self, descriptor)

    fn create_sampler(self, descriptor: SamplerDescriptor) -> Sampler:
        """
        TODO
        """
        return Sampler(self, descriptor)

    fn create_shader_module(
        self, code: StringSlice
    ) raises -> ShaderModule:
        """
        TODO
        """
        return ShaderModule(self, code)

    fn create_texture(self, descriptor: TextureDescriptor) -> Texture:
        """
        TODO
        """
        return Texture(self, descriptor)

    fn destroy(self):
        """
        TODO
        """
        _c.device_destroy(self._handle)

    # fn device_get_limits(handle: WGPUDevice, limits: WGPUSupportedLimits) -> Bool:
    #     """
    #     TODO
    #     """
    #     return _wgpu.get_function[
    #         fn (WGPUDevice, UnsafePointer[WGPUSupportedLimits]) -> Bool
    #     ]("wgpuDeviceGetLimits")(handle, UnsafePointer.address_of(limits))

    fn has_feature(self, feature: FeatureName) -> Bool:
        """
        TODO
        """
        return _c.device_has_feature(self._handle, feature)

    fn enumerate_features(self, features: FeatureName) -> UInt:
        """
        TODO
        """
        return _c.device_enumerate_features(self._handle, features)

    fn get_queue(self) -> Queue:
        """
        TODO
        """
        return Queue(self)


# fn device_push_error_scope(handle: WGPUDevice, filter: ErrorFilter) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUDevice, ErrorFilter) -> None](
#         "wgpuDevicePushErrorScope"
#     )(handle, filter)


# fn device_pop_error_scope(
#     handle: WGPUDevice,
#     callback: ErrorCallback,
#     userdata: UnsafePointer[NoneType],
# ) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (WGPUDevice, ErrorCallback, UnsafePointer[NoneType]) -> None
#     ]("wgpuDevicePopErrorScope")(handle, callback, userdata)


# fn device_set_label(handle: WGPUDevice, label: UnsafePointer[Int8]) -> None:
#     """
#     TODO
#     """
#     return _wgpu.get_function[fn (WGPUDevice, UnsafePointer[Int8]) -> None](
#         "wgpuDeviceSetLabel"
#     )(handle, label)
