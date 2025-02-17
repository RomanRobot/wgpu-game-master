from memory import Span, UnsafePointer
from collections.string import StringSlice
from collections import Optional

import . _cffi as _c

from .command_encoder import CommandEncoder
from .pipeline_layout import PipelineLayout
from .texture import Texture
from .shader_module import ShaderModule
from .texture_view import TextureView
from .adapter import Adapter
from .surface import SurfaceTexture

alias Limits = _c.WGPULimits
alias BlendComponent = _c.WGPUBlendComponent
alias Extent3D = _c.WGPUExtent3D
alias Origin3D = _c.WGPUOrigin3D
alias VertexAttribute = _c.WGPUVertexAttribute
alias Color = _c.WGPUColor
alias BlendState = _c.WGPUBlendState
alias StencilFaceState = _c.WGPUStencilFaceState
alias BindGroup = _c.WGPUBindGroup
alias BindGroupLayout = _c.WGPUBindGroupLayout
alias BindGroupLayoutEntry = _c.WGPUBindGroupLayoutEntry
alias BindGroupEntry = _c.WGPUBindGroupEntry
alias BufferBindingLayout = _c.WGPUBufferBindingLayout

@value
struct BindGroupLayoutDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var entries: List[BindGroupLayoutEntry]

@value
struct BindGroupDescriptor:
    """
    TODO
    """

    var label: StringLiteral

    var layout: BindGroupLayoutDescriptor
    var entries: List[BindGroupEntry]

# @value
# struct BufferDescriptor:
#     """
#     TODO
#     """

#     var label: StringLiteral
#     var usage: BufferUsage
#     var size: UInt
#     var mapped_at_creation: Bool

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
    var bind_group_layouts: List[BindGroupLayout]

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
struct QueueDescriptor:
    """
    TODO
    """

    var label: String

    fn __init__(out self, label: String = String()):
        self.label = label

@value
struct QuerySetDescriptor:
    """
    TODO
    """

    var label: StringLiteral
    var type: QueryType
    var count: UInt32

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
struct MultisampleState:
    """
    TODO
    """

    var count: UInt32
    var mask: UInt32
    var alpha_to_coverage_enabled: Bool

    fn __init__(
        out self,
        count: UInt32 = 1,
        mask: UInt32 = ~0,
        alpha_to_coverage_enabled: Bool = False,
    ):
        self.count = count
        self.mask = mask
        self.alpha_to_coverage_enabled = alpha_to_coverage_enabled

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

struct CommandBuffer:
    var _handle: _c.WGPUCommandBuffer

    fn __init__(out self, command_encoder: CommandEncoder, label: StringLiteral = ""):
        self._handle = _c.command_encoder_finish(
            command_encoder._handle,
            _c.WGPUCommandBufferDescriptor(label=label.unsafe_cstr_ptr()),
        )

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUCommandBuffer()

    fn __del__(owned self):
        if self._handle:
            _c.command_buffer_release(self._handle)

    fn set_label(self, label: StringSlice):
        """
        TODO
        """
        _c.command_buffer_set_label(
            self._handle, label.unsafe_ptr().bitcast[Int8]()
        )

struct Sampler:
    var _handle: _c.WGPUSampler

    fn __init__(out self, device: Device, descriptor: SamplerDescriptor):
        self._handle = _c.device_create_sampler(
            device._handle,
            _c.WGPUSamplerDescriptor(
                label=descriptor.label.unsafe_cstr_ptr(),
                address_mode_u=descriptor.address_mode_u,
                address_mode_v=descriptor.address_mode_v,
                address_mode_w=descriptor.address_mode_w,
                mag_filter=descriptor.mag_filter,
                min_filter=descriptor.min_filter,
                mipmap_filter=descriptor.mipmap_filter,
                lod_min_clamp=descriptor.lod_min_clamp,
                lod_max_clamp=descriptor.lod_max_clamp,
                compare=descriptor.compare,
                max_anisotropy=descriptor.max_anisotropy,
            ),
        )

    # fn __moveinit__(mut self, owned rhs: Self):
    #     self._handle = rhs._handle
    #     rhs._handle = _c.WGPUSampler()

    fn __del__(owned self):
        if self._handle:
            _c.sampler_release(self._handle)

    fn set_label(self, label: StringSlice):
        """
        TODO
        """
        _c.sampler_set_label(self._handle, label.unsafe_ptr().bitcast[Int8]())

struct SurfaceCapabilities:
    """
    TODO
    """

    var _handle: _c.WGPUSurfaceCapabilities

    fn __init__(out self, surface: Surface, adapter: Adapter):
        self._handle = _c.WGPUSurfaceCapabilities()
        _c.surface_get_capabilities(surface._handle, adapter._handle, self._handle)

    fn __del__(owned self):
        _c.surface_capabilities_free_members(self._handle)

    fn usages(self) -> TextureUsage:
        return self._handle.usages

    fn formats(self) -> Span[TextureFormat, __origin_of(self)]:
        return Span[TextureFormat, __origin_of(self)](
            ptr=self._handle.formats, length=self._handle.format_count
        )

    # fn present_modes(self) -> Span[PresentMode, __origin_of(self)]:
    #     return Span[PresentMode, __origin_of(self)](
    #         ptr=self._handle.present_modes,
    #         length=self._handle.present_mode_count,
    #     )

    # fn alpha_modes(self) -> Span[CompositeAlphaMode, __origin_of(self)]:
    #     return Span[CompositeAlphaMode, __origin_of(self)](
    #         ptr=self._handle.alpha_modes,
    #         length=self._handle.alpha_mode_count,
    #     )

struct RenderPassColorAttachment:
    """
    TODO
    """

    var view: TextureView
    var depth_slice: UInt32
    # TODO: RenderPassColorAttachment.resolve_target
    #var resolve_target: Optional[ArcPointer[TextureView]]
    var load_op: LoadOp
    var store_op: StoreOp
    var clear_value: Color

    fn __init__(
        out self,
        texture: Texture,
        texture_view_descriptor: TextureViewDescriptor,
        load_op: LoadOp,
        store_op: StoreOp,
        #resolve_target: Optional[ArcPointer[TextureView]] = None,
        clear_value: Color = Color(),
        depth_slice: UInt32 = DEPTH_SLICE_UNDEFINED,
    ):
        self.view = TextureView(texture, texture_view_descriptor)
        self.load_op = load_op
        self.store_op = store_op
        #self.resolve_target = resolve_target
        self.clear_value = clear_value
        self.depth_slice = depth_slice

    fn __init__(
        out self,
        surface_texture: SurfaceTexture,
        texture_view_descriptor: TextureViewDescriptor,
        load_op: LoadOp,
        store_op: StoreOp,
        #resolve_target: Optional[ArcPointer[TextureView]] = None,
        clear_value: Color = Color(),
        depth_slice: UInt32 = DEPTH_SLICE_UNDEFINED,
    ):
        self.view = TextureView(surface_texture, texture_view_descriptor)
        self.load_op = load_op
        self.store_op = store_op
        #self.resolve_target = resolve_target
        self.clear_value = clear_value
        self.depth_slice = depth_slice

struct RenderPassDepthStencilAttachment:
    """
    TODO
    """

    var view: TextureView
    var depth_load_op: LoadOp
    var depth_store_op: StoreOp
    var depth_clear_value: Float32
    var depth_read_only: Bool
    var stencil_load_op: LoadOp
    var stencil_store_op: StoreOp
    var stencil_clear_value: UInt32
    var stencil_read_only: Bool
