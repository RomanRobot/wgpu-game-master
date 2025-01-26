from wgpu import *
from sys.info import sizeof

from memory import Span, UnsafePointer
from collections import Optional, InlineArray

from vec import *
from mat import *
from constants import *

@value
struct MyColor:
    var r: Float32
    var g: Float32
    var b: Float32
    var a: Float32

@value
struct MyVertex:
    var pos: Vec4
    var color: MyColor

fn on_uniform_map(status: BufferMapAsyncStatus, user_data: UnsafePointer[NoneType]) -> None:
    return

def main():
    glfw.init()
    window = glfw.Window(640, 480, "Hello, WebGPU")

    instance = wgpu.Instance()
    surface = instance.create_surface(window)

    adapter = instance.request_adapter_sync()

    device = adapter.adapter_request_device()

    queue = device.get_queue()

    surface_capabilies = surface.get_capabilities(adapter)
    surface_format = surface_capabilies.formats()[0]
    surface.configure(
        width=640,
        height=480,
        usage=TextureUsage.render_attachment,
        format=surface_format,
        device=device,
        alpha_mode=CompositeAlphaMode.auto,
        present_mode=PresentMode.fifo,
    )

    shader_code = """
        struct Uniforms {
            mvp: mat4x4<f32>,
        };

        @group(0) @binding(0)
        var<uniform> uniforms: Uniforms;

        struct VertexOutput {
            @builtin(position) position: vec4<f32>,
            @location(1) color: vec4<f32>,
        };

        @vertex
        fn vs_main(@location(0) in_pos: vec4<f32>, @location(1) in_color: vec4<f32>) -> VertexOutput {
            var output: VertexOutput;
            output.position = in_pos * uniforms.mvp;
            output.color = in_color;
            return output;
        }

        @fragment
        fn fs_main(@location(1) in_color: vec4<f32>) -> @location(0) vec4<f32> {
            return in_color;
        }
        """

    shader_module = device.create_wgsl_shader_module(code=shader_code)

    vertex_attributes = List[VertexAttribute](
        VertexAttribute(format=VertexFormat.float32x4, offset=0, shader_location=0),
        VertexAttribute(format=VertexFormat.float32x4, offset=sizeof[Vec4](), shader_location=1)
    )

    vertex_buffer_layout = VertexBufferLayout[StaticConstantOrigin](
        array_stride=sizeof[MyVertex](),
        step_mode=VertexStepMode.vertex,
        attributes=Span[VertexAttribute, StaticConstantOrigin](ptr=vertex_attributes.unsafe_ptr(), length=len(vertex_attributes))
    )

    vertices = InlineArray[MyVertex, 3](
        MyVertex(Vec4(-0.5, -0.5, 0.0, 1.0), MyColor(1, 0, 0, 1)),
        MyVertex(Vec4(0.5, -0.5, 0.0, 1.0), MyColor(0, 1, 0, 1)),
        MyVertex(Vec4(0.0, 0.5, 0.0, 1.0), MyColor(0, 0, 1, 1))
    )
    vertex_buffer = device.create_buffer(BufferDescriptor(
        label="vertex buffer", #StringLiteral
        usage=BufferUsage.vertex, #BufferUsage
        size=len(vertices) * sizeof[MyVertex](), #UInt64
        mapped_at_creation=True #Bool
    ))
    dst = vertex_buffer.get_mapped_range().bitcast[MyVertex]()
    for i in range(len(vertices)):
        dst[i] = vertices[i]
    vertex_buffer.unmap()

    model = mat4_identity()
    view = mat4_translation(0.0, 0.0, -1.0)
    projection = mat4_perspective(fov=pi*0.5, aspect=480.0/640.0, near=0.1, far=1000.0)
    mvp = mat4_mul(mat4_mul(projection, view), model)
    uniform_buffer = device.create_buffer(BufferDescriptor(
        label="uniform buffer", #StringLiteral
        usage=BufferUsage.uniform | BufferUsage.copy_dst, #BufferUsage
        size=sizeof[Mat4](), #UInt64
        mapped_at_creation=True #Bool
    ))
    udst = uniform_buffer.get_mapped_range(0, sizeof[Mat4]()).bitcast[Mat4]()
    udst[] = mvp
    uniform_buffer.unmap()

    bind_groups, bind_group_layouts = device.create_bind_groups(List[BindGroupDescriptor](BindGroupDescriptor(
        label="bind group",
        layout=BindGroupLayoutDescriptor(
            label="bind group layout",
            entries=List[BindGroupLayoutEntry](BindGroupLayoutEntry(
                binding=0, #UInt32
                visibility=ShaderStage.vertex, #ShaderStage
                buffer=BufferBindingLayout(
                    type=BufferBindingType.uniform, #BufferBindingType
                    has_dynamic_offset=False, #Bool
                    min_binding_size=sizeof[Mat4](), #UInt64
                ), #BufferBindingLayout
            ))
        ), #BindGroupLayoutDescriptor
        entries=List[BindGroupEntry](BindGroupEntry(
            binding=0, #UInt32
            buffer=uniform_buffer._handle, #UnsafePointer[_BufferImpl]
            offset=0, #UInt64
            size=sizeof[Mat4](), #UInt64
        )), #List[BindGroupEntry]
    )))

    # TODO: Figure out how to ergonomically pass these handles like BindGroupLayout around.
    # ArcPointer is nice but not nullable.
    # Optional[ArcPointer] maybe?
    # device create functions could return ArcPointers that handle release.
    # cffi functions can undig raw, unsafe ptrs
    # No more copying of arrays in interface functions...
    # The thing in memory should be the actual thing, not a description used to build on demand.
    # You can have fancy CRUD interfaces.

    pipeline_layout = device.create_pipeline_layout(PipelineLayoutDescriptor(
        label="pipeline layout", # StringLiteral
        bind_group_layouts=bind_group_layouts # List[ArcPointer[BindGroupLayout]]
    ))
    pipeline = device.create_render_pipeline(RenderPipelineDescriptor(
        label="render pipeline",
        vertex=VertexState(
            entry_point="vs_main",
            module=shader_module,
            buffers=List[VertexBufferLayout[StaticConstantOrigin]](vertex_buffer_layout),
        ),
        fragment=FragmentState(
            module=shader_module,
            entry_point="fs_main",
            targets=List[ColorTargetState](
                ColorTargetState(
                    blend=BlendState(
                        color=BlendComponent(
                            src_factor=BlendFactor.src_alpha,
                            dst_factor=BlendFactor.one_minus_src_alpha,
                            operation=BlendOperation.add,
                        ),
                        alpha=BlendComponent(
                            src_factor=BlendFactor.zero,
                            dst_factor=BlendFactor.one,
                            operation=BlendOperation.add,
                        ),
                    ),
                    format=surface_format,
                    write_mask=ColorWriteMask.all,
                )
            ),
        ),
        primitive=PrimitiveState(
            topology=PrimitiveTopology.triangle_list,
        ),
        multisample=MultisampleState(),
        layout=pipeline_layout,
        depth_stencil=None,
    ))

    var tri_angle: Float32 = 0.0
    while not window.should_close():
        glfw.poll_events()
        with surface.get_current_texture() as surface_tex:
            if (
                surface_tex.status
                != SurfaceGetCurrentTextureStatus.success
            ):
                raise Error("failed to get surface tex")
            target_view = surface_tex.texture[].create_view(
                format=surface_tex.texture[].get_format(),
                dimension=TextureViewDimension.d2,
                base_mip_level=0,
                mip_level_count=1,
                base_array_layer=0,
                array_layer_count=1,
                aspect=TextureAspect.all,
            )
            color_attachments = List[RenderPassColorAttachment](
                RenderPassColorAttachment(
                    view=target_view,
                    load_op=LoadOp.clear,
                    store_op=StoreOp.store,
                    clear_value=Color(0.9, 0.1, 0.2, 1.0),
                )
            )

            tri_angle += 0.01
            model = mat4_rotation_y(tri_angle)
            mvp = mat4_mul(mat4_mul(projection, view), model)

            # TODO: Do this in a less horrible way.
            var dst = InlineArray[Float32, 16](0)
            for i in range(16):
                dst[i] = mvp[i]
            queue.write_buffer(uniform_buffer, dst.unsafe_ptr().bitcast[NoneType]())

            encoder = device.create_command_encoder()
            rp = encoder.begin_render_pass(color_attachments=color_attachments)
            rp.set_pipeline(pipeline)
            rp.set_vertex_buffer(0, vertex_buffer)
            rp.set_bind_group(0, 0, UnsafePointer[UInt32](), bind_groups[0])
            rp.draw(3, 1, 0, 0)
            rp.end()

            queue.submit(encoder.finish())
            surface.present()

    glfw.terminate()
