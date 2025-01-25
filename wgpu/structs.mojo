from collections import Optional
from utils import Variant
from memory import Span, ArcPointer
from collections.string import StringSlice

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
struct RequestAdapterOptions[surface: ImmutableOrigin, window: ImmutableOrigin]:
    var power_preference: PowerPreference
    var force_fallback_adapter: Bool
    var compatible_surface: Optional[Pointer[Surface[window], surface]]

    fn __init__(
        out self,
        power_preference: PowerPreference = PowerPreference.undefined,
        force_fallback_adapter: Bool = False,
        compatible_surface: Optional[Pointer[Surface[window], surface]] = None,
    ):
        self.power_preference = power_preference
        self.force_fallback_adapter = force_fallback_adapter
        self.compatible_surface = compatible_surface


struct AdapterInfo[origin: ImmutableOrigin]:
    """
    TODO
    """

    var vendor: StringSlice[origin]
    var architecture: StringSlice[origin]
    var device: StringSlice[origin]
    var description: StringSlice[origin]
    var backend_type: BackendType
    var adapter_type: AdapterType
    var vendor_ID: UInt32
    var device_ID: UInt32


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
        out self,
        label: StringLiteral = "",
        required_features: Optional[List[FeatureName]] = None,
        limits: Limits = Limits(),
        default_queue: QueueDescriptor = QueueDescriptor(),
    ):
        self.label = label
        self.required_features = required_features
        self.limits = limits
        self.default_queue = default_queue


# @value
# struct BindGroupEntry:
#     """
#     TODO
#     """

#     var binding: UInt32
#     var buffer: ArcPointer[Buffer]
#     var offset: UInt64
#     var size: UInt64
#     var sampler: ArcPointer[Sampler]
#     var texture_view: ArcPointer[TextureView]
alias BindGroupEntry = _c.WGPUBindGroupEntry

@value
struct BindGroupDescriptor:
    """
    TODO
    """

    var label: StringLiteral

    var layout: BindGroupLayoutDescriptor
    var entries: List[BindGroupEntry]


# @value
# struct BufferBindingLayout:
#     """
#     TODO
#     """

#     var type: BufferBindingType
#     var has_dynamic_offset: Bool
#     var min_binding_size: UInt64
alias BufferBindingLayout = _c.WGPUBufferBindingLayout

@value
struct SamplerBindingLayout:
    """
    TODO
    """

    var type: SamplerBindingType


@value
struct TextureBindingLayout:
    """
    TODO
    """

    var sample_type: TextureSampleType
    var view_dimension: TextureViewDimension
    var multisampled: Bool


struct SurfaceCapabilities:
    """
    TODO
    """

    var _handle: _c.WGPUSurfaceCapabilities

    fn __init__(out self, unsafe_ptr: _c.WGPUSurfaceCapabilities):
        self._handle = unsafe_ptr

    fn __del__(owned self):
        _c.surface_capabilities_free_members(self._handle)

    fn usages(self) -> TextureUsage:
        return self._handle.usages

    fn formats(self) -> Span[TextureFormat, __origin_of(self)]:
        return Span[TextureFormat, __origin_of(self)](
            ptr=self._handle.formats, length=self._handle.format_count
        )

    fn present_modes(self) -> Span[PresentMode, __origin_of(self)]:
        return Span[PresentMode, __origin_of(self)](
            ptr=self._handle.present_modes,
            length=self._handle.present_mode_count,
        )

    fn alpha_modes(self) -> Span[CompositeAlphaMode, __origin_of(self)]:
        return Span[CompositeAlphaMode, __origin_of(self)](
            ptr=self._handle.alpha_modes,
            length=self._handle.alpha_mode_count,
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
        out self,
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


@value
struct StorageTextureBindingLayout:
    """
    TODO
    """

    var access: StorageTextureAccess
    var format: TextureFormat
    var view_dimension: TextureViewDimension


# @value
# struct BindGroupLayoutEntry:
#     """
#     TODO
#     """

#     var binding: UInt32
#     var visibility: ShaderStage
#     var buffer: BufferBindingLayout
#     var sampler: SamplerBindingLayout
#     var texture: TextureBindingLayout
#     var storage_texture: StorageTextureBindingLayout
alias BindGroupLayoutEntry = _c.WGPUBindGroupLayoutEntry

@value
struct BindGroupLayoutDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var entries: List[BindGroupLayoutEntry]


@value
struct BufferDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var usage: BufferUsage
    var size: UInt
    var mapped_at_creation: Bool


@value
struct ConstantEntry:
    """
    TODO
    """

    var key: String
    var value: Float64


@value
struct CommandBufferDescriptor:
    """
    TODO
    """

    var label: StringLiteral


@value
struct CommandEncoderDescriptor:
    """
    TODO
    """

    var label: StringLiteral


@value
struct WGPUCompilationInfo:
    """
    TODO
    """

    var messages: List[CompilationMessage]


@value
struct CompilationMessage:
    """
    TODO
    """

    var message: StringLiteral
    var type: CompilationMessageType
    var line_num: UInt64
    var line_pos: UInt64
    var offset: UInt64
    var length: UInt64
    var utf16_line_pos: UInt64
    var utf16_offset: UInt64
    var utf16_length: UInt64


@value
struct ComputePassDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var timestamp_writes: Optional[ComputePassTimestampWrites]


@value
struct ComputePassTimestampWrites:
    """
    TODO
    """

    var query_set: ArcPointer[QuerySet]
    var beginning_of_pass_write_index: UInt32
    var end_of_pass_write_index: UInt32


@value
struct ComputePipelineDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var layout: ArcPointer[PipelineLayout]
    var compute: ProgrammableStageDescriptor


@value
struct ImageCopyBuffer[buf: ImmutableOrigin]:
    """
    TODO
    """

    var layout: TextureDataLayout
    var buffer: Pointer[Buffer, buf]

    fn __init__(
        out self,
        ref [buf]buffer: Buffer,
        layout: TextureDataLayout = TextureDataLayout(),
    ):
        self.buffer = Pointer.address_of(buffer)
        self.layout = layout


@value
struct ImageCopyTexture[tex: ImmutableOrigin]:
    """
    TODO
    """

    var texture: Pointer[Texture, tex]
    var mip_level: UInt32
    var origin: Origin3D
    var aspect: TextureAspect

    fn __init__(
        out self,
        ref [tex]texture: Texture,
        mip_level: UInt32 = 0,
        origin: Origin3D = Origin3D(),
        aspect: TextureAspect = TextureAspect.all,
    ):
        self.texture = Pointer.address_of(texture)
        self.mip_level = mip_level
        self.origin = origin
        self.aspect = aspect


@value
struct VertexBufferLayout[origin: ImmutableOrigin]:
    """
    TODO
    """

    var array_stride: UInt64
    var step_mode: VertexStepMode
    var attributes: Span[VertexAttribute, origin]

@value
struct PipelineLayoutDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var bind_group_layouts: List[_c.WGPUBindGroupLayout]


@value
struct ProgrammableStageDescriptor:
    """
    TODO
    """

    var module: ArcPointer[ShaderModule]
    var entry_point: StringLiteral
    var constants: List[ConstantEntry]


@value
struct QuerySetDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var type: QueryType
    var count: UInt32


@value
struct QueueDescriptor:
    """
    TODO
    """

    var label: String

    fn __init__(out self, label: String = String()):
        self.label = label


@value
struct RenderBundleDescriptor:
    """
    TODO
    """

    var label: StringLiteral


@value
struct RenderBundleEncoderDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var color_formats: List[TextureFormat]
    var depth_stencil_format: TextureFormat
    var sample_count: UInt32
    var depth_read_only: Bool
    var stencil_read_only: Bool


@value
struct RenderPassColorAttachment:
    """
    TODO
    """

    var view: ArcPointer[TextureView]
    var depth_slice: UInt32
    var resolve_target: Optional[ArcPointer[TextureView]]
    var load_op: LoadOp
    var store_op: StoreOp
    var clear_value: Color

    fn __init__(
        out self,
        view: ArcPointer[TextureView],
        load_op: LoadOp,
        store_op: StoreOp,
        *,
        resolve_target: Optional[ArcPointer[TextureView]] = None,
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

    var view: ArcPointer[TextureView]
    var depth_load_op: LoadOp
    var depth_store_op: StoreOp
    var depth_clear_value: Float32
    var depth_read_only: Bool
    var stencil_load_op: LoadOp
    var stencil_store_op: StoreOp
    var stencil_clear_value: UInt32
    var stencil_read_only: Bool


struct RenderPassDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var color_attachments: List[RenderPassColorAttachment]
    var depth_stencil_attachment: Optional[RenderPassDepthStencilAttachment]
    var occlusion_query_set: QuerySet
    var timestamp_writes: Optional[RenderPassTimestampWrites]


@value
struct RenderPassDescriptorMaxDrawCount:
    """
    TODO
    """

    var max_draw_count: UInt64


@value
struct RenderPassTimestampWrites:
    """
    TODO
    """

    var query_set: ArcPointer[QuerySet]
    var beginning_of_pass_write_index: UInt32
    var end_of_pass_write_index: UInt32


@value
struct VertexState[
    mod: ImmutableOrigin,
    entry: ImmutableOrigin,
    buf: ImmutableOrigin,
    vbuf: ImmutableOrigin,
]:
    """
    TODO
    """

    var module: Pointer[ShaderModule, mod]
    var entry_point: StringSlice[entry]
    # var constants: Span[ConstantEntry, lifetime]
    var buffers: Span[VertexBufferLayout[vbuf], buf]

    fn __init__(
        out self,
        ref [mod]module: ShaderModule,
        entry_point: StringSlice[entry],
        buffers: Span[VertexBufferLayout[vbuf], buf],
    ):
        self.module = Pointer.address_of(module)
        self.entry_point = entry_point
        self.buffers = buffers


@value
struct PrimitiveState:
    """
    TODO
    """

    var topology: PrimitiveTopology
    var strip_index_format: IndexFormat
    var front_face: FrontFace
    var cull_mode: CullMode

    fn __init__(
        out self,
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


@value
struct PrimitiveDepthClipControl:
    """
    TODO
    """

    var unclipped_depth: Bool


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
        out self,
        *,
        count: UInt32 = 1,
        mask: UInt32 = ~0,
        alpha_to_coverage_enabled: Bool = False,
    ):
        self.count = count
        self.mask = mask
        self.alpha_to_coverage_enabled = alpha_to_coverage_enabled


@value
struct FragmentState[
    mod: ImmutableOrigin, entry: ImmutableOrigin, tgt: ImmutableOrigin
]:
    """
    TODO
    """

    var module: Pointer[ShaderModule, mod]
    var entry_point: StringSlice[entry]
    # var constants: Span[ConstantEntry, lifetime]
    var targets: Span[ColorTargetState, tgt]

    fn __init__(
        out self,
        *,
        ref [mod]module: ShaderModule,
        entry_point: StringSlice[entry],
        # constants: Span[ConstantEntry],
        targets: Span[ColorTargetState, tgt],
    ):
        self.module = Pointer.address_of(module)
        self.entry_point = entry_point
        # self.constants = constants
        self.targets = targets


@value
struct ColorTargetState:
    """
    TODO
    """

    var format: TextureFormat
    var blend: Optional[BlendState]
    var write_mask: ColorWriteMask


@value
struct RenderPipelineDescriptor[
    vmod: ImmutableOrigin,
    ventry: ImmutableOrigin,
    buf: ImmutableOrigin,
    vbuf: ImmutableOrigin,
    fmod: ImmutableOrigin,
    fentry: ImmutableOrigin,
    tgt: ImmutableOrigin,
]:
    """
    TODO
    """

    var label: StringLiteral
    var layout: PipelineLayout
    var vertex: VertexState[vmod, ventry, buf, vbuf]
    var primitive: PrimitiveState
    var depth_stencil: Optional[DepthStencilState]
    var multisample: MultisampleState
    var fragment: Optional[FragmentState[fmod, fentry, tgt]]


@value
struct SamplerDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var address_mode_u: AddressMode
    var address_mode_v: AddressMode
    var address_mode_w: AddressMode
    var mag_filter: FilterMode
    var min_filter: FilterMode
    var mipmap_filter: MipmapFilterMode
    var lod_min_clamp: Float32
    var lod_max_clamp: Float32
    var compare: CompareFunction
    var max_anisotropy: UInt16


@value
struct ShaderModuleDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var hints: List[ShaderModuleCompilationHint]


@value
struct ShaderModuleCompilationHint:
    """
    TODO
    """

    var entry_point: StringLiteral
    var layout: ArcPointer[PipelineLayout]


@value
struct SurfaceDescriptor:
    """
    TODO
    """

    var label: StringLiteral


@value
struct SurfaceTexture:
    """
    TODO
    """

    var texture: ArcPointer[Texture]
    var suboptimal: Bool
    var status: SurfaceGetCurrentTextureStatus

    fn __init__(
        out self,
        texture: ArcPointer[Texture],
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
        out self,
        offset: UInt64 = 0,
        bytes_per_row: Optional[UInt32] = None,
        rows_per_image: Optional[UInt32] = None,
    ):
        self.offset = offset
        self.bytes_per_row = bytes_per_row
        self.rows_per_image = rows_per_image


struct TextureDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var usage: TextureUsage
    var dimension: TextureDimension
    var size: Extent3D
    var format: TextureFormat
    var mip_level_count: UInt32
    var sample_count: UInt32
    var view_formats: List[TextureFormat]


@value
struct TextureViewDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var format: TextureFormat
    var dimension: TextureViewDimension
    var base_mip_level: UInt32
    var mip_level_count: UInt32
    var base_array_layer: UInt32
    var array_layer_count: UInt32
    var aspect: TextureAspect


@value
struct UncapturedErrorCallbackInfo:
    """
    TODO
    """

    var callback: UnsafePointer[NoneType]
    var userdata: UnsafePointer[NoneType]
