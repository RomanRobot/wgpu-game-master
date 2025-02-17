import src as wgpu
from sys.info import sizeof

from memory import Span, UnsafePointer
from collections import Optional, InlineArray
from math import pi

alias Vec4 = SIMD[DType.float32, 4]

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

def main():
    print("begin!")
    wgpu.init()
    window_width = 640
    window_height = 480
    wgpu.window_hint(wgpu.CLIENT_API, wgpu.NO_API)
    window = wgpu.Window(window_width, window_height, "Hello, WebGPU")

    instance = wgpu.Instance()
    surface = wgpu.Surface[__origin_of(window)](instance, window.get_cocoa_window().bitcast[NoneType]())

    print("before adapter")
    adapter = instance.request_adapter_sync(surface)
    print("after adapter")
    device = adapter.request_device()
    queue = device.get_queue()

    surface_capabilities = surface.get_capabilities(adapter)
    surface_format = surface_capabilities.formats()[0]
    surface.configure(
        width=window_width,
        height=window_height,
        usage=wgpu.TextureUsage.render_attachment,
        format=surface_format,
        device=device,
        alpha_mode=wgpu.CompositeAlphaMode.auto,
        present_mode=wgpu.PresentMode.fifo,
    )

    shader_code = """
        @group(0) @binding(0)
        var<uniform> value: f32;

        struct VertexOutput {
            @builtin(position) position: vec4<f32>,
            @location(1) color: vec4<f32>,
        };

        @vertex
        fn vs_main(@location(0) in_pos: vec4<f32>, @location(1) in_color: vec4<f32>) -> VertexOutput {
            var output: VertexOutput;
            output.position = in_pos * value;
            output.color = in_color;
            return output;
        }

        @fragment
        fn fs_main(@location(1) in_color: vec4<f32>) -> @location(0) vec4<f32> {
            return in_color;
        }
        """
    shader_module = device.create_shader_module(code=shader_code)

    vertex_attributes = List[wgpu.VertexAttribute](
        wgpu.VertexAttribute(format=wgpu.VertexFormat.float32x4, offset=0, shader_location=0),
        wgpu.VertexAttribute(format=wgpu.VertexFormat.float32x4, offset=sizeof[Vec4](), shader_location=1)
    )
    vertex_buffer_layout = wgpu.VertexBufferLayout[StaticConstantOrigin](
        array_stride=sizeof[MyVertex](),
        step_mode=wgpu.VertexStepMode.vertex,
        attributes=Span[wgpu.VertexAttribute, StaticConstantOrigin](ptr=vertex_attributes.unsafe_ptr(), length=len(vertex_attributes))
    )

    vertices = InlineArray[MyVertex, 3](
        MyVertex(Vec4(-0.5, -0.5, 0.0, 1.0), MyColor(1, 0, 0, 1)),
        MyVertex(Vec4(0.5, -0.5, 0.0, 1.0), MyColor(0, 1, 0, 1)),
        MyVertex(Vec4(0.0, 0.5, 0.0, 1.0), MyColor(0, 0, 1, 1))
    )
    vertex_buffer = device.create_buffer(
        label="vertex buffer", #StringLiteral
        usage=wgpu.BufferUsage.vertex, #BufferUsage
        size=len(vertices) * sizeof[MyVertex](), #UInt64
        mapped_at_creation=True #Bool
    )
    dst = vertex_buffer.get_mapped_range().bitcast[MyVertex]()
    # for i in range(len(vertices)):
    #     dst[i] = vertices[i]
    dst[0] = vertices[0]
    dst[1] = vertices[1]
    dst[2] = vertices[2]
    vertex_buffer.unmap()

    uniform_value = Float32(1.0)
    uniform_buffer = device.create_buffer(
        label="uniform buffer", #StringLiteral
        usage=wgpu.BufferUsage.uniform | wgpu.BufferUsage.copy_dst, #BufferUsage
        size=sizeof[__type_of(uniform_value)](), #UInt64
        mapped_at_creation=True #Bool
    )
    uniform_mapped = uniform_buffer.get_mapped_range(0, sizeof[__type_of(uniform_value)]()).bitcast[__type_of(uniform_value)]()
    uniform_mapped[] = uniform_value
    uniform_buffer.unmap()

    bind_groups, bind_group_layouts = device.create_bind_groups(List[wgpu.BindGroupDescriptor](wgpu.BindGroupDescriptor(
        label="bind group",
        layout=wgpu.BindGroupLayoutDescriptor(
            label="bind group layout",
            entries=List[wgpu.BindGroupLayoutEntry](wgpu.BindGroupLayoutEntry(
                binding=0, #UInt32
                visibility=wgpu.ShaderStage.vertex, #ShaderStage
                buffer=wgpu.BufferBindingLayout(
                    type=wgpu.BufferBindingType.uniform, #BufferBindingType
                    has_dynamic_offset=False, #Bool
                    min_binding_size=sizeof[__type_of(uniform_value)](), #UInt64
                ), #BufferBindingLayout
            ))
        ), #BindGroupLayoutDescriptor
        entries=List[wgpu.BindGroupEntry](wgpu.BindGroupEntry(
            binding=0, #UInt32
            buffer=uniform_buffer._handle, #UnsafePointer[_BufferImpl]
            offset=0, #UInt64
            size=sizeof[__type_of(uniform_value)](), #UInt64
        )), #List[BindGroupEntry]
    )))
    pipeline_layout = device.create_pipeline_layout(wgpu.PipelineLayoutDescriptor(
        label="pipeline layout", # StringLiteral
        bind_group_layouts=bind_group_layouts # List[BindGroupLayout]
    ))
    print("sup")
    render_pipeline = device.create_render_pipeline(wgpu.RenderPipelineDescriptor(
        label="render pipeline",
        vertex=wgpu.VertexState(
            entry_point="vs_main",
            module=shader_module,
            buffers=List[wgpu.VertexBufferLayout[StaticConstantOrigin]](vertex_buffer_layout),
        ),
        fragment=wgpu.FragmentState(
            module=shader_module,
            entry_point="fs_main",
            targets=List[wgpu.ColorTargetState](
                wgpu.ColorTargetState(
                    blend=wgpu.BlendState(
                        color=wgpu.BlendComponent(
                            src_factor=wgpu.BlendFactor.src_alpha,
                            dst_factor=wgpu.BlendFactor.one_minus_src_alpha,
                            operation=wgpu.BlendOperation.add,
                        ),
                        alpha=wgpu.BlendComponent(
                            src_factor=wgpu.BlendFactor.zero,
                            dst_factor=wgpu.BlendFactor.one,
                            operation=wgpu.BlendOperation.add,
                        ),
                    ),
                    format=surface_format,
                    write_mask=wgpu.ColorWriteMask.all,
                )
            ),
        ),
        primitive=wgpu.PrimitiveState(
            topology=wgpu.PrimitiveTopology.triangle_list,
        ),
        multisample=wgpu.MultisampleState(),
        layout=pipeline_layout,
        depth_stencil=None,
    ))

    while not window.should_close():
        wgpu.poll_events()

        # tri_angle += 0.01
        # model = Mat4.rotation_y(tri_angle)
        # mvp = model * view_projection
        # # TODO: Do this in a less horrible way.
        # var dst = InlineArray[Float32, 16](0)
        # for i in range(16):
        #     dst[i] = mvp[i]
        # queue.write_buffer(uniform_buffer, UnsafePointer.address_of(dst).bitcast[UInt8]())
        
        surface_tex = surface.get_current_texture()
        if surface_tex.status != wgpu.SurfaceGetCurrentTextureStatus.success:
            raise Error("failed to get surface tex")
        color_attachment = wgpu.RenderPassColorAttachment(
            surface_texture=surface_tex,
            texture_view_descriptor=wgpu.TextureViewDescriptor(
                label="surface texture view",
                format=surface_format,#surface_tex.texture[].get_format(),
                dimension=wgpu.TextureViewDimension.d2,
                base_mip_level=0,
                mip_level_count=1,
                base_array_layer=0,
                array_layer_count=1,
                aspect=wgpu.TextureAspect.all,
            ),
            load_op=wgpu.LoadOp.clear,
            store_op=wgpu.StoreOp.store,
            clear_value=wgpu.Color(0.9, 0.1, 0.2, 1.0),
        )

        encoder = device.create_command_encoder()
        rp = encoder.begin_render_pass(color_attachment=color_attachment)
        # rp.set_pipeline(render_pipeline)
        # rp.set_vertex_buffer(0, vertex_buffer)
        # rp.set_bind_group(0, 0, UnsafePointer[UInt32](), bind_groups[0])
        # rp.draw(len(vertices), 1, 0, 0)
        rp.end()
        queue.submit(encoder.finish())

        surface.present()

    wgpu.terminate()
