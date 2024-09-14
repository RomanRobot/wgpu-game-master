from collections import Optional
from utils import StringSlice, Span, Variant
from memory import Arc

from .bitflags import *
from .constants import *
from .enums import *
from .objects import *


import . _cffi as _c

alias Limits = _c.WGPULimits
alias BlendComponent = _c.WGPUBlendComponent
alias Extent3D = _c.WGPUExtent3D
alias Origin3D = _c.WGPUOrigin3D
alias VertexAttribute = _c.WGPUVertexAttribute
alias Color = _c.WGPUColor
alias BlendState = _c.WGPUBlendState
alias StencilFaceState = _c.WGPUStencilFaceState


@value
struct RequestAdapterOptions[
    surface: ImmutableLifetime, window: ImmutableLifetime
]:
    var power_preference: PowerPreference
    var force_fallback_adapter: Bool
    var compatible_surface: Optional[Reference[Surface[window], surface]]

    fn __init__(
        inout self,
        power_preference: PowerPreference = PowerPreference.undefined,
        force_fallback_adapter: Bool = False,
        compatible_surface: Optional[
            Reference[Surface[window], surface]
        ] = None,
    ):
        self.power_preference = power_preference
        self.force_fallback_adapter = force_fallback_adapter
        self.compatible_surface = compatible_surface


# @value
# struct AdapterInfo:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStructOut]
#     var vendor: UnsafePointer[Int8]
#     var architecture: UnsafePointer[Int8]
#     var device: UnsafePointer[Int8]
#     var description: UnsafePointer[Int8]
#     var backend_type: BackendType
#     var adapter_type: AdapterType
#     var vendor_ID: UInt32
#     var device_ID: UInt32

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStructOut] = UnsafePointer[
#             ChainedStructOut
#         ](),
#         vendor: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         architecture: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         device: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         description: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         backend_type: BackendType = BackendType(0),
#         adapter_type: AdapterType = AdapterType(0),
#         vendor_ID: UInt32 = UInt32(),
#         device_ID: UInt32 = UInt32(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.vendor = vendor
#         self.architecture = architecture
#         self.device = device
#         self.description = description
#         self.backend_type = backend_type
#         self.adapter_type = adapter_type
#         self.vendor_ID = vendor_ID
#         self.device_ID = device_ID


@value
struct DeviceDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var required_features: Optional[List[FeatureName]]
    var limits: Limits
    var default_queue: QueueDescriptor
    # var device_lost_callback: UnsafePointer[NoneType]
    # var device_lost_userdata: UnsafePointer[NoneType]
    # var uncaptured_error_callback_info: UnsafePointer[NoneType]

    fn __init__(
        inout self,
        label: StringLiteral = "",
        required_features: Optional[List[FeatureName]] = None,
        limits: Limits = Limits(),
        default_queue: QueueDescriptor = QueueDescriptor(),
    ):
        self.label = label
        self.required_features = required_features
        self.limits = limits
        self.default_queue = default_queue


# struct WGPUBindGroupEntry:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var binding: UInt32
#     var buffer: WGPUBuffer
#     var offset: UInt64
#     var size: UInt64
#     var sampler: WGPUSampler
#     var texture_view: WGPUTextureView

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         binding: UInt32 = UInt32(),
#         buffer: WGPUBuffer = WGPUBuffer(),
#         offset: UInt64 = UInt64(),
#         size: UInt64 = UInt64(),
#         sampler: WGPUSampler = WGPUSampler(),
#         texture_view: WGPUTextureView = WGPUTextureView(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.binding = binding
#         self.buffer = buffer
#         self.offset = offset
#         self.size = size
#         self.sampler = sampler
#         self.texture_view = texture_view


# struct WGPUBindGroupDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var layout: WGPUBindGroupLayout
#     var entries_count: Int
#     var entries: UnsafePointer[WGPUBindGroupEntry]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         layout: WGPUBindGroupLayout = WGPUBindGroupLayout(),
#         entries_count: Int = Int(),
#         entries: UnsafePointer[WGPUBindGroupEntry] = UnsafePointer[
#             WGPUBindGroupEntry
#         ](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.layout = layout
#         self.entries_count = entries_count
#         self.entries = entries


# struct WGPUBufferBindingLayout:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var type: BufferBindingType
#     var has_dynamic_offset: Bool
#     var min_binding_size: UInt64

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         type: BufferBindingType = BufferBindingType(0),
#         has_dynamic_offset: Bool = False,
#         min_binding_size: UInt64 = UInt64(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.type = type
#         self.has_dynamic_offset = has_dynamic_offset
#         self.min_binding_size = min_binding_size


# struct WGPUSamplerBindingLayout:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var type: SamplerBindingType

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         type: SamplerBindingType = SamplerBindingType(0),
#     ):
#         self.next_in_chain = next_in_chain
#         self.type = type


# struct WGPUTextureBindingLayout:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var sample_type: TextureSampleType
#     var view_dimension: TextureViewDimension
#     var multisampled: Bool

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         sample_type: TextureSampleType = TextureSampleType(0),
#         view_dimension: TextureViewDimension = TextureViewDimension(0),
#         multisampled: Bool = False,
#     ):
#         self.next_in_chain = next_in_chain
#         self.sample_type = sample_type
#         self.view_dimension = view_dimension
#         self.multisampled = multisampled


struct SurfaceCapabilities:
    """
    TODO
    """

    var _handle: _c.WGPUSurfaceCapabilities

    fn __init__(inout self, unsafe_ptr: _c.WGPUSurfaceCapabilities):
        self._handle = unsafe_ptr

    fn __del__(owned self):
        _c.surface_capabilities_free_members(self._handle)

    fn usages(self) -> TextureUsage:
        return self._handle.usages

    fn formats(self) -> Span[TextureFormat, __lifetime_of(self)]:
        return Span[TextureFormat, __lifetime_of(self)](
            unsafe_ptr=self._handle.formats, len=self._handle.format_count
        )

    fn present_modes(self) -> Span[PresentMode, __lifetime_of(self)]:
        return Span[PresentMode, __lifetime_of(self)](
            unsafe_ptr=self._handle.present_modes,
            len=self._handle.present_mode_count,
        )

    fn alpha_modes(self) -> Span[CompositeAlphaMode, __lifetime_of(self)]:
        return Span[CompositeAlphaMode, __lifetime_of(self)](
            unsafe_ptr=self._handle.alpha_modes,
            len=self._handle.alpha_mode_count,
        )


@value
struct SurfaceConfiguration:
    """
    TODO
    """

    var format: TextureFormat
    var usage: TextureUsage
    var view_formats: List[TextureFormat]
    var alpha_mode: CompositeAlphaMode
    var width: UInt32
    var height: UInt32
    var present_mode: PresentMode

    fn __init__(
        inout self,
        format: TextureFormat,
        usage: TextureUsage,
        view_formats: List[TextureFormat],
        alpha_mode: CompositeAlphaMode,
        width: UInt32,
        height: UInt32,
        present_mode: PresentMode,
    ):
        self.format = format
        self.usage = usage
        self.view_formats = view_formats
        self.alpha_mode = alpha_mode
        self.width = width
        self.height = height
        self.present_mode = present_mode


# struct WGPUStorageTextureBindingLayout:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var access: StorageTextureAccess
#     var format: TextureFormat
#     var view_dimension: TextureViewDimension

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         access: StorageTextureAccess = StorageTextureAccess(0),
#         format: TextureFormat = TextureFormat(0),
#         view_dimension: TextureViewDimension = TextureViewDimension(0),
#     ):
#         self.next_in_chain = next_in_chain
#         self.access = access
#         self.format = format
#         self.view_dimension = view_dimension


# struct WGPUBindGroupLayoutEntry:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var binding: UInt32
#     var visibility: ShaderStage
#     var buffer: WGPUBufferBindingLayout
#     var sampler: WGPUSamplerBindingLayout
#     var texture: WGPUTextureBindingLayout
#     var storage_texture: WGPUStorageTextureBindingLayout

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         binding: UInt32 = UInt32(),
#         visibility: ShaderStage = ShaderStage(0),
#         owned buffer: WGPUBufferBindingLayout = WGPUBufferBindingLayout(),
#         owned sampler: WGPUSamplerBindingLayout = WGPUSamplerBindingLayout(),
#         owned texture: WGPUTextureBindingLayout = WGPUTextureBindingLayout(),
#         owned storage_texture: WGPUStorageTextureBindingLayout = WGPUStorageTextureBindingLayout(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.binding = binding
#         self.visibility = visibility
#         self.buffer = buffer^
#         self.sampler = sampler^
#         self.texture = texture^
#         self.storage_texture = storage_texture^


# struct WGPUBindGroupLayoutDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var entries_count: Int
#     var entries: UnsafePointer[WGPUBindGroupLayoutEntry]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         entries_count: Int = Int(),
#         entries: UnsafePointer[WGPUBindGroupLayoutEntry] = UnsafePointer[
#             WGPUBindGroupLayoutEntry
#         ](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.entries_count = entries_count
#         self.entries = entries


# struct WGPUBufferDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var usage: BufferUsage
#     var size: UInt64
#     var mapped_at_creation: Bool

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         usage: BufferUsage = BufferUsage(0),
#         size: UInt64 = UInt64(),
#         mapped_at_creation: Bool = False,
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.usage = usage
#         self.size = size
#         self.mapped_at_creation = mapped_at_creation


# struct WGPUColor:
#     """
#     TODO
#     """

#     var r: Float64
#     var g: Float64
#     var b: Float64
#     var a: Float64

#     fn __init__(
#         inout self,
#         r: Float64 = Float64(),
#         g: Float64 = Float64(),
#         b: Float64 = Float64(),
#         a: Float64 = Float64(),
#     ):
#         self.r = r
#         self.g = g
#         self.b = b
#         self.a = a


@value
struct ConstantEntry:
    """
    TODO
    """

    var key: String
    var value: Float64


# struct WGPUCommandBufferDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label


# struct WGPUCommandEncoderDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label


# struct WGPUCompilationInfo:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var messages_count: Int
#     var messages: UnsafePointer[WGPUCompilationMessage]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         messages_count: Int = Int(),
#         messages: UnsafePointer[WGPUCompilationMessage] = UnsafePointer[
#             WGPUCompilationMessage
#         ](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.messages_count = messages_count
#         self.messages = messages


# struct WGPUCompilationMessage:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var message: UnsafePointer[Int8]
#     var type: CompilationMessageType
#     var line_num: UInt64
#     var line_pos: UInt64
#     var offset: UInt64
#     var length: UInt64
#     var utf16_line_pos: UInt64
#     var utf16_offset: UInt64
#     var utf16_length: UInt64

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         message: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         type: CompilationMessageType = CompilationMessageType(0),
#         line_num: UInt64 = UInt64(),
#         line_pos: UInt64 = UInt64(),
#         offset: UInt64 = UInt64(),
#         length: UInt64 = UInt64(),
#         utf16_line_pos: UInt64 = UInt64(),
#         utf16_offset: UInt64 = UInt64(),
#         utf16_length: UInt64 = UInt64(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.message = message
#         self.type = type
#         self.line_num = line_num
#         self.line_pos = line_pos
#         self.offset = offset
#         self.length = length
#         self.utf16_line_pos = utf16_line_pos
#         self.utf16_offset = utf16_offset
#         self.utf16_length = utf16_length


# struct WGPUComputePassDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var timestamp_writes: UnsafePointer[WGPUComputePassTimestampWrites]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         timestamp_writes: UnsafePointer[
#             WGPUComputePassTimestampWrites
#         ] = UnsafePointer[WGPUComputePassTimestampWrites](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.timestamp_writes = timestamp_writes


# struct WGPUComputePassTimestampWrites:
#     """
#     TODO
#     """

#     var query_set: WGPUQuerySet
#     var beginning_of_pass_write_index: UInt32
#     var end_of_pass_write_index: UInt32

#     fn __init__(
#         inout self,
#         query_set: WGPUQuerySet = WGPUQuerySet(),
#         beginning_of_pass_write_index: UInt32 = UInt32(),
#         end_of_pass_write_index: UInt32 = UInt32(),
#     ):
#         self.query_set = query_set
#         self.beginning_of_pass_write_index = beginning_of_pass_write_index
#         self.end_of_pass_write_index = end_of_pass_write_index


# struct WGPUComputePipelineDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var layout: WGPUPipelineLayout
#     var compute: WGPUProgrammableStageDescriptor

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         layout: WGPUPipelineLayout = WGPUPipelineLayout(),
#         owned compute: WGPUProgrammableStageDescriptor = WGPUProgrammableStageDescriptor(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.layout = layout
#         self.compute = compute^


@value
struct ImageCopyBuffer[buf: ImmutableLifetime]:
    """
    TODO
    """

    var layout: TextureDataLayout
    var buffer: Reference[Buffer, buf]

    fn __init__(
        inout self,
        ref [buf]buffer: Buffer,
        layout: TextureDataLayout = TextureDataLayout(),
    ):
        self.buffer = buffer
        self.layout = layout


@value
struct ImageCopyTexture[tex: ImmutableLifetime]:
    """
    TODO
    """

    var texture: Reference[Texture, tex]
    var mip_level: UInt32
    var origin: Origin3D
    var aspect: TextureAspect

    fn __init__(
        inout self,
        ref [tex]texture: Texture,
        mip_level: UInt32 = 0,
        origin: Origin3D = Origin3D(),
        aspect: TextureAspect = TextureAspect.all,
    ):
        self.texture = texture
        self.mip_level = mip_level
        self.origin = origin
        self.aspect = aspect


# struct WGPUVertexAttribute:
#     """
#     TODO
#     """

#     var format: VertexFormat
#     var offset: UInt64
#     var shader_location: UInt32

#     fn __init__(
#         inout self,
#         format: VertexFormat = VertexFormat(0),
#         offset: UInt64 = UInt64(),
#         shader_location: UInt32 = UInt32(),
#     ):
#         self.format = format
#         self.offset = offset
#         self.shader_location = shader_location


@value
struct VertexBufferLayout[lifetime: ImmutableLifetime]:
    """
    TODO
    """

    var array_stride: UInt64
    var step_mode: VertexStepMode
    var attributes: Span[VertexAttribute, lifetime]


# struct WGPUPipelineLayoutDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var bind_group_layouts_count: Int
#     var bind_group_layouts: UnsafePointer[WGPUBindGroupLayout]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         bind_group_layouts_count: Int = Int(),
#         bind_group_layouts: UnsafePointer[WGPUBindGroupLayout] = UnsafePointer[
#             WGPUBindGroupLayout
#         ](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.bind_group_layouts_count = bind_group_layouts_count
#         self.bind_group_layouts = bind_group_layouts


# struct WGPUProgrammableStageDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var module: WGPUShaderModule
#     var entry_point: UnsafePointer[Int8]
#     var constants_count: Int
#     var constants: UnsafePointer[WGPUConstantEntry]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         module: WGPUShaderModule = WGPUShaderModule(),
#         entry_point: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         constants_count: Int = Int(),
#         constants: UnsafePointer[WGPUConstantEntry] = UnsafePointer[
#             WGPUConstantEntry
#         ](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.module = module
#         self.entry_point = entry_point
#         self.constants_count = constants_count
#         self.constants = constants


# struct WGPUQuerySetDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var type: QueryType
#     var count: UInt32

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         type: QueryType = QueryType(0),
#         count: UInt32 = UInt32(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.type = type
#         self.count = count


@value
struct QueueDescriptor:
    """
    TODO
    """

    var label: String

    fn __init__(inout self, label: String = String()):
        self.label = label


# struct WGPURenderBundleDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label


# struct WGPURenderBundleEncoderDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var color_formats_count: Int
#     var color_formats: UnsafePointer[TextureFormat]
#     var depth_stencil_format: TextureFormat
#     var sample_count: UInt32
#     var depth_read_only: Bool
#     var stencil_read_only: Bool

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         color_formats_count: Int = Int(),
#         color_formats: UnsafePointer[TextureFormat] = UnsafePointer[
#             TextureFormat
#         ](),
#         depth_stencil_format: TextureFormat = TextureFormat(0),
#         sample_count: UInt32 = UInt32(),
#         depth_read_only: Bool = False,
#         stencil_read_only: Bool = False,
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.color_formats_count = color_formats_count
#         self.color_formats = color_formats
#         self.depth_stencil_format = depth_stencil_format
#         self.sample_count = sample_count
#         self.depth_read_only = depth_read_only
#         self.stencil_read_only = stencil_read_only


@value
struct RenderPassColorAttachment:
    """
    TODO
    """

    var view: Arc[TextureView]
    var depth_slice: UInt32
    var resolve_target: Optional[Arc[TextureView]]
    var load_op: LoadOp
    var store_op: StoreOp
    var clear_value: Color

    fn __init__(
        inout self,
        view: Arc[TextureView],
        load_op: LoadOp,
        store_op: StoreOp,
        *,
        resolve_target: Optional[Arc[TextureView]] = None,
        clear_value: Color = Color(),
        depth_slice: UInt32 = DEPTH_SLICE_UNDEFINED,
    ):
        self.view = view
        self.load_op = load_op
        self.store_op = store_op
        self.resolve_target = resolve_target
        self.clear_value = clear_value
        self.depth_slice = depth_slice


@value
struct RenderPassDepthStencilAttachment:
    """
    TODO
    """

    var view: Arc[TextureView]
    var depth_load_op: LoadOp
    var depth_store_op: StoreOp
    var depth_clear_value: Float32
    var depth_read_only: Bool
    var stencil_load_op: LoadOp
    var stencil_store_op: StoreOp
    var stencil_clear_value: UInt32
    var stencil_read_only: Bool


#     fn __init__(
#         inout self,
#         view: WGPUTextureView = WGPUTextureView(),
#         depth_load_op: LoadOp = LoadOp(0),
#         depth_store_op: StoreOp = StoreOp(0),
#         depth_clear_value: Float32 = Float32(),
#         depth_read_only: Bool = False,
#         stencil_load_op: LoadOp = LoadOp(0),
#         stencil_store_op: StoreOp = StoreOp(0),
#         stencil_clear_value: UInt32 = UInt32(),
#         stencil_read_only: Bool = False,
#     ):
#         self.view = view
#         self.depth_load_op = depth_load_op
#         self.depth_store_op = depth_store_op
#         self.depth_clear_value = depth_clear_value
#         self.depth_read_only = depth_read_only
#         self.stencil_load_op = stencil_load_op
#         self.stencil_store_op = stencil_store_op
#         self.stencil_clear_value = stencil_clear_value
#         self.stencil_read_only = stencil_read_only


# struct WGPURenderPassDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var color_attachments_count: Int
#     var color_attachments: UnsafePointer[WGPURenderPassColorAttachment]
#     var depth_stencil_attachment: UnsafePointer[
#         WGPURenderPassDepthStencilAttachment
#     ]
#     var occlusion_query_set: WGPUQuerySet
#     var timestamp_writes: UnsafePointer[WGPURenderPassTimestampWrites]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         color_attachments_count: Int = Int(),
#         color_attachments: UnsafePointer[
#             WGPURenderPassColorAttachment
#         ] = UnsafePointer[WGPURenderPassColorAttachment](),
#         depth_stencil_attachment: UnsafePointer[
#             WGPURenderPassDepthStencilAttachment
#         ] = UnsafePointer[WGPURenderPassDepthStencilAttachment](),
#         occlusion_query_set: WGPUQuerySet = WGPUQuerySet(),
#         timestamp_writes: UnsafePointer[
#             WGPURenderPassTimestampWrites
#         ] = UnsafePointer[WGPURenderPassTimestampWrites](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.color_attachments_count = color_attachments_count
#         self.color_attachments = color_attachments
#         self.depth_stencil_attachment = depth_stencil_attachment
#         self.occlusion_query_set = occlusion_query_set
#         self.timestamp_writes = timestamp_writes


# struct WGPURenderPassDescriptorMaxDrawCount:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var max_draw_count: UInt64

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         max_draw_count: UInt64 = UInt64(),
#     ):
#         self.chain = chain
#         self.max_draw_count = max_draw_count


# struct WGPURenderPassTimestampWrites:
#     """
#     TODO
#     """

#     var query_set: WGPUQuerySet
#     var beginning_of_pass_write_index: UInt32
#     var end_of_pass_write_index: UInt32

#     fn __init__(
#         inout self,
#         query_set: WGPUQuerySet = WGPUQuerySet(),
#         beginning_of_pass_write_index: UInt32 = UInt32(),
#         end_of_pass_write_index: UInt32 = UInt32(),
#     ):
#         self.query_set = query_set
#         self.beginning_of_pass_write_index = beginning_of_pass_write_index
#         self.end_of_pass_write_index = end_of_pass_write_index


struct VertexState[
    mod: ImmutableLifetime, entry: ImmutableLifetime, buf: ImmutableLifetime
]:
    """
    TODO
    """

    var module: Reference[ShaderModule, mod]
    var entry_point: StringSlice[entry]
    # var constants: Span[ConstantEntry, lifetime]
    var buffers: Span[VertexBufferLayout[buf], buf]

    fn __init__(
        inout self,
        ref [mod]module: ShaderModule,
        entry_point: StringSlice[entry],
        buffers: Span[VertexBufferLayout[buf], buf],
    ):
        self.module = module
        self.entry_point = StringSlice(
            unsafe_from_utf8=entry_point.as_bytes_slice()
        )
        self.buffers = buffers

    fn __moveinit__(inout self, owned rhs: Self):
        self.module = rhs.module
        self.entry_point = StringSlice(
            unsafe_from_utf8=rhs.entry_point.as_bytes_slice()
        )
        self.buffers = rhs.buffers

    fn __copyinit__(inout self, rhs: Self):
        self.module = rhs.module
        self.entry_point = StringSlice(
            unsafe_from_utf8=rhs.entry_point.as_bytes_slice()
        )
        self.buffers = rhs.buffers


struct PrimitiveState:
    """
    TODO
    """

    var topology: PrimitiveTopology
    var strip_index_format: IndexFormat
    var front_face: FrontFace
    var cull_mode: CullMode

    fn __init__(
        inout self,
        *,
        topology: PrimitiveTopology = PrimitiveTopology(0),
        strip_index_format: IndexFormat = IndexFormat(0),
        front_face: FrontFace = FrontFace(0),
        cull_mode: CullMode = CullMode(0),
    ):
        self.topology = topology
        self.strip_index_format = strip_index_format
        self.front_face = front_face
        self.cull_mode = cull_mode

    fn __moveinit__(inout self, owned rhs: Self):
        self.topology = rhs.topology
        self.strip_index_format = rhs.strip_index_format
        self.front_face = rhs.front_face
        self.cull_mode = rhs.cull_mode

    fn __copyinit__(inout self, rhs: Self):
        self.topology = rhs.topology
        self.strip_index_format = rhs.strip_index_format
        self.front_face = rhs.front_face
        self.cull_mode = rhs.cull_mode


# struct WGPUPrimitiveDepthClipControl:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var unclipped_depth: Bool

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         unclipped_depth: Bool = False,
#     ):
#         self.chain = chain
#         self.unclipped_depth = unclipped_depth


@value
struct DepthStencilState:
    """
    TODO
    """

    var format: TextureFormat
    var depth_write_enabled: Bool
    var depth_compare: CompareFunction
    var stencil_front: StencilFaceState
    var stencil_back: StencilFaceState
    var stencil_read_mask: UInt32
    var stencil_write_mask: UInt32
    var depth_bias: Int32
    var depth_bias_slope_scale: Float32
    var depth_bias_clamp: Float32


@value
struct MultisampleState:
    """
    TODO
    """

    var count: UInt32
    var mask: UInt32
    var alpha_to_coverage_enabled: Bool

    fn __init__(
        inout self,
        *,
        count: UInt32 = 1,
        mask: UInt32 = ~0,
        alpha_to_coverage_enabled: Bool = False,
    ):
        self.count = count
        self.mask = mask
        self.alpha_to_coverage_enabled = alpha_to_coverage_enabled


#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         count: UInt32 = UInt32(),
#         mask: UInt32 = UInt32(),
#         alpha_to_coverage_enabled: Bool = False,
#     ):
#         self.next_in_chain = next_in_chain
#         self.count = count
#         self.mask = mask
#         self.alpha_to_coverage_enabled = alpha_to_coverage_enabled


struct FragmentState[
    mod: ImmutableLifetime, entry: ImmutableLifetime, tgt: ImmutableLifetime
]:
    """
    TODO
    """

    var module: Reference[ShaderModule, mod]
    var entry_point: StringSlice[entry]
    # var constants: Span[ConstantEntry, lifetime]
    var targets: Span[ColorTargetState, tgt]

    fn __init__(
        inout self,
        *,
        ref [mod]module: ShaderModule,
        entry_point: StringSlice[entry],
        # constants: Span[ConstantEntry],
        targets: Span[ColorTargetState, tgt],
    ):
        self.module = module
        self.entry_point = StringSlice(
            unsafe_from_utf8=entry_point.as_bytes_slice()
        )
        # self.constants = constants
        self.targets = targets

    fn __moveinit__(inout self, owned rhs: Self):
        self.module = rhs.module
        self.entry_point = StringSlice(
            unsafe_from_utf8=rhs.entry_point.as_bytes_slice()
        )
        self.targets = rhs.targets

    fn __copyinit__(inout self, rhs: Self):
        self.module = rhs.module
        self.entry_point = StringSlice(
            unsafe_from_utf8=rhs.entry_point.as_bytes_slice()
        )
        self.targets = rhs.targets


struct ColorTargetState:
    """
    TODO
    """

    var format: TextureFormat
    var blend: Optional[BlendState]
    var write_mask: ColorWriteMask

    fn __init__(
        inout self,
        format: TextureFormat,
        write_mask: ColorWriteMask,
        blend: Optional[BlendState],
    ):
        self.format = format
        self.blend = blend
        self.write_mask = write_mask

    fn __moveinit__(inout self, owned rhs: Self):
        self.format = rhs.format
        self.blend = rhs.blend
        self.write_mask = rhs.write_mask

    fn __copyinit__(inout self, rhs: Self):
        self.format = rhs.format
        self.blend = rhs.blend
        self.write_mask = rhs.write_mask


struct RenderPipelineDescriptor[
    lyt: ImmutableLifetime,
    mod: ImmutableLifetime,
    entry: ImmutableLifetime,
    buf: ImmutableLifetime,
    tgt: ImmutableLifetime,
]:
    """
    TODO
    """

    var label: StringLiteral
    var layout: Optional[Reference[PipelineLayout, lyt]]
    var vertex: VertexState[mod, entry, buf]
    var primitive: PrimitiveState
    var depth_stencil: Optional[DepthStencilState]
    var multisample: MultisampleState
    var fragment: Optional[FragmentState[mod, entry, tgt]]

    fn __init__(
        inout self,
        *,
        label: StringLiteral,
        vertex: VertexState[mod, entry, buf],
        primitive: PrimitiveState,
        multisample: MultisampleState,
        layout: Optional[Reference[PipelineLayout, lyt]] = None,
        depth_stencil: Optional[DepthStencilState] = None,
        fragment: Optional[FragmentState[mod, entry, tgt]] = None,
    ):
        self.label = label
        self.vertex = vertex
        self.primitive = primitive
        self.multisample = multisample
        self.layout = layout
        self.depth_stencil = depth_stencil
        self.fragment = fragment

    fn __moveinit__(inout self, owned rhs: Self):
        self.label = rhs.label
        self.vertex = rhs.vertex
        self.primitive = rhs.primitive
        self.multisample = rhs.multisample
        self.layout = rhs.layout
        self.depth_stencil = rhs.depth_stencil
        self.fragment = rhs.fragment

    fn __copyinit__(inout self, rhs: Self):
        self.label = rhs.label
        self.vertex = rhs.vertex
        self.primitive = rhs.primitive
        self.multisample = rhs.multisample
        self.layout = rhs.layout
        self.depth_stencil = rhs.depth_stencil
        self.fragment = rhs.fragment


# struct WGPUSamplerDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var address_mode_u: AddressMode
#     var address_mode_v: AddressMode
#     var address_mode_w: AddressMode
#     var mag_filter: FilterMode
#     var min_filter: FilterMode
#     var mipmap_filter: MipmapFilterMode
#     var lod_min_clamp: Float32
#     var lod_max_clamp: Float32
#     var compare: CompareFunction
#     var max_anisotropy: UInt16

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         address_mode_u: AddressMode = AddressMode(0),
#         address_mode_v: AddressMode = AddressMode(0),
#         address_mode_w: AddressMode = AddressMode(0),
#         mag_filter: FilterMode = FilterMode(0),
#         min_filter: FilterMode = FilterMode(0),
#         mipmap_filter: MipmapFilterMode = MipmapFilterMode(0),
#         lod_min_clamp: Float32 = Float32(),
#         lod_max_clamp: Float32 = Float32(),
#         compare: CompareFunction = CompareFunction(0),
#         max_anisotropy: UInt16 = UInt16(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.address_mode_u = address_mode_u
#         self.address_mode_v = address_mode_v
#         self.address_mode_w = address_mode_w
#         self.mag_filter = mag_filter
#         self.min_filter = min_filter
#         self.mipmap_filter = mipmap_filter
#         self.lod_min_clamp = lod_min_clamp
#         self.lod_max_clamp = lod_max_clamp
#         self.compare = compare
#         self.max_anisotropy = max_anisotropy


# struct WGPUShaderModuleDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var hints_count: Int
#     var hints: UnsafePointer[WGPUShaderModuleCompilationHint]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         hints_count: Int = Int(),
#         hints: UnsafePointer[WGPUShaderModuleCompilationHint] = UnsafePointer[
#             WGPUShaderModuleCompilationHint
#         ](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.hints_count = hints_count
#         self.hints = hints


# struct WGPUShaderModuleCompilationHint:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var entry_point: UnsafePointer[Int8]
#     var layout: WGPUPipelineLayout

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         entry_point: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         layout: WGPUPipelineLayout = WGPUPipelineLayout(),
#     ):
#         self.next_in_chain = next_in_chain
#         self.entry_point = entry_point
#         self.layout = layout


# struct WGPUShaderModuleSpirvDescriptor:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var code_size: UInt32
#     var code: UInt32

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         code_size: UInt32 = UInt32(),
#         code: UInt32 = UInt32(),
#     ):
#         self.chain = chain
#         self.code_size = code_size
#         self.code = code


# struct WGPUShaderModuleWgslDescriptor:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var code: UnsafePointer[Int8]

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         code: UnsafePointer[Int8] = UnsafePointer[Int8](),
#     ):
#         self.chain = chain
#         self.code = code


# struct WGPUSurfaceDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label


# struct WGPUSurfaceDescriptorFromAndroidNativeWindow:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var window: UnsafePointer[NoneType]

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         window: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#     ):
#         self.chain = chain
#         self.window = window


# struct WGPUSurfaceDescriptorFromCanvasHtmlSelector:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var selector: UnsafePointer[Int8]

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         selector: UnsafePointer[Int8] = UnsafePointer[Int8](),
#     ):
#         self.chain = chain
#         self.selector = selector


# struct WGPUSurfaceDescriptorFromMetalLayer:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var layer: UnsafePointer[NoneType]

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         layer: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#     ):
#         self.chain = chain
#         self.layer = layer


# struct WGPUSurfaceDescriptorFromWindowsHwnd:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var hinstance: UnsafePointer[NoneType]
#     var hwnd: UnsafePointer[NoneType]

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         hinstance: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#         hwnd: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#     ):
#         self.chain = chain
#         self.hinstance = hinstance
#         self.hwnd = hwnd


# struct WGPUSurfaceDescriptorFromXcbWindow:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var connection: UnsafePointer[NoneType]
#     var window: UInt32

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         connection: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#         window: UInt32 = UInt32(),
#     ):
#         self.chain = chain
#         self.connection = connection
#         self.window = window


# struct WGPUSurfaceDescriptorFromXlibWindow:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var display: UnsafePointer[NoneType]
#     var window: UInt64

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         display: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#         window: UInt64 = UInt64(),
#     ):
#         self.chain = chain
#         self.display = display
#         self.window = window


# struct WGPUSurfaceDescriptorFromWaylandSurface:
#     """
#     TODO
#     """

#     var chain: ChainedStruct
#     var display: UnsafePointer[NoneType]
#     var surface: UnsafePointer[NoneType]

#     fn __init__(
#         inout self,
#         chain: ChainedStruct = ChainedStruct(),
#         display: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#         surface: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#     ):
#         self.chain = chain
#         self.display = display
#         self.surface = surface


@value
struct SurfaceTexture:
    """
    TODO
    """

    var texture: Arc[Texture]
    var suboptimal: Bool
    var status: SurfaceGetCurrentTextureStatus

    fn __init__(
        inout self,
        texture: Arc[Texture],
        suboptimal: Bool = False,
        status: SurfaceGetCurrentTextureStatus = SurfaceGetCurrentTextureStatus(
            0
        ),
    ):
        self.texture = texture
        self.suboptimal = suboptimal
        self.status = status

    fn __enter__(self) -> Self:
        return self


@value
struct TextureDataLayout:
    """
    TODO
    """

    var offset: UInt64
    var bytes_per_row: Optional[UInt32]
    var rows_per_image: Optional[UInt32]

    fn __init__(
        inout self,
        offset: UInt64 = 0,
        bytes_per_row: Optional[UInt32] = None,
        rows_per_image: Optional[UInt32] = None,
    ):
        self.offset = offset
        self.bytes_per_row = bytes_per_row
        self.rows_per_image = rows_per_image


# struct WGPUTextureDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var usage: TextureUsage
#     var dimension: TextureDimension
#     var size: WGPUExtent3D
#     var format: TextureFormat
#     var mip_level_count: UInt32
#     var sample_count: UInt32
#     var view_formats_count: Int
#     var view_formats: UnsafePointer[TextureFormat]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         usage: TextureUsage = TextureUsage(0),
#         dimension: TextureDimension = TextureDimension(0),
#         owned size: WGPUExtent3D = WGPUExtent3D(),
#         format: TextureFormat = TextureFormat(0),
#         mip_level_count: UInt32 = UInt32(),
#         sample_count: UInt32 = UInt32(),
#         view_formats_count: Int = Int(),
#         view_formats: UnsafePointer[TextureFormat] = UnsafePointer[
#             TextureFormat
#         ](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.usage = usage
#         self.dimension = dimension
#         self.size = size^
#         self.format = format
#         self.mip_level_count = mip_level_count
#         self.sample_count = sample_count
#         self.view_formats_count = view_formats_count
#         self.view_formats = view_formats


# struct WGPUTextureViewDescriptor:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var label: UnsafePointer[Int8]
#     var format: TextureFormat
#     var dimension: TextureViewDimension
#     var base_mip_level: UInt32
#     var mip_level_count: UInt32
#     var base_array_layer: UInt32
#     var array_layer_count: UInt32
#     var aspect: TextureAspect

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         label: UnsafePointer[Int8] = UnsafePointer[Int8](),
#         format: TextureFormat = TextureFormat(0),
#         dimension: TextureViewDimension = TextureViewDimension(0),
#         base_mip_level: UInt32 = UInt32(),
#         mip_level_count: UInt32 = UInt32(),
#         base_array_layer: UInt32 = UInt32(),
#         array_layer_count: UInt32 = UInt32(),
#         aspect: TextureAspect = TextureAspect(0),
#     ):
#         self.next_in_chain = next_in_chain
#         self.label = label
#         self.format = format
#         self.dimension = dimension
#         self.base_mip_level = base_mip_level
#         self.mip_level_count = mip_level_count
#         self.base_array_layer = base_array_layer
#         self.array_layer_count = array_layer_count
#         self.aspect = aspect


# struct WGPUUncapturedErrorCallbackInfo:
#     """
#     TODO
#     """

#     var next_in_chain: UnsafePointer[ChainedStruct]
#     var callback: UnsafePointer[NoneType]
#     var userdata: UnsafePointer[NoneType]

#     fn __init__(
#         inout self,
#         next_in_chain: UnsafePointer[ChainedStruct] = UnsafePointer[
#             ChainedStruct
#         ](),
#         callback: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#         userdata: UnsafePointer[NoneType] = UnsafePointer[NoneType](),
#     ):
#         self.next_in_chain = next_in_chain
#         self.callback = callback
#         self.userdata = userdata


# fn create_instance(
#     descriptor: WGPUInstanceDescriptor = WGPUInstanceDescriptor(),
# ) -> WGPUInstance:
#     """
#     TODO
#     """
#     return _wgpu.get_function[
#         fn (UnsafePointer[WGPUInstanceDescriptor]) -> WGPUInstance
#     ]("wgpuCreateInstance")(UnsafePointer.address_of(descriptor))
