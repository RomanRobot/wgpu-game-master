import wgpu
from wgpu import glfw

from utils import Span
from collections import Optional


def main():
    glfw.init()
    window = glfw.Window(640, 480, "Hello, WebGPU")

    instance = wgpu.Instance()
    if not instance._handle:
        raise Error("failed to get instance")

    surface = instance.create_surface(window)
    if not surface._handle:
        raise Error("failed to get surface")

    adapter = instance.request_adapter_sync()

    if not adapter._handle:
        raise Error("failed to get adapter")

    device = adapter.adapter_request_device()
    if not device._handle:
        raise Error("failed to get device")

    queue = device.get_queue()
    if not queue._handle:
        raise Error("failed to get queue")

    surface_capabilies = surface.get_capabilities(adapter)
    surface_format = surface_capabilies.formats()[0]
    surface.configure(
        width=640,
        height=480,
        usage=wgpu.TextureUsage.render_attachment,
        format=surface_format,
        device=device,
        alpha_mode=wgpu.CompositeAlphaMode.auto,
        present_mode=wgpu.PresentMode.fifo,
    )

    shader_code = """
        @vertex
        fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> @builtin(position) vec4<f32> {
           	var p = vec2<f32>(0.0, 0.0);
           	if (in_vertex_index == 0u) {
          		p = vec2<f32>(-0.5, -0.5);
           	} else if (in_vertex_index == 1u) {
          		p = vec2<f32>(0.5, -0.5);
           	} else {
          		p = vec2<f32>(0.0, 0.5);
           	}
           	return vec4<f32>(p, 0.0, 1.0);
        }

        @fragment
        fn fs_main() -> @location(0) vec4<f32> {
           	return vec4<f32>(0.0, 0.4, 1.0, 1.0);
        }
        """

    shader_module = device.create_wgsl_shader_module(code=shader_code)

    if not shader_module._handle:
        raise Error("failed to create shader module")

    targets = List[wgpu.ColorTargetState](
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
    )

    pipeline = device.create_render_pipeline(
        descriptor=wgpu.RenderPipelineDescriptor[
            ImmutableStaticLifetime,
            __lifetime_of(shader_module),
            ImmutableStaticLifetime,
            ImmutableStaticLifetime,
            __lifetime_of(targets),
        ](
            label="render pipeline",
            vertex=wgpu.VertexState[
                __lifetime_of(shader_module),
                ImmutableStaticLifetime,
                ImmutableStaticLifetime,
            ](
                entry_point="vs_main".as_string_slice(),
                module=shader_module,
                buffers=List[
                    wgpu.VertexBufferLayout[ImmutableStaticLifetime]
                ](),
            ),
            fragment=wgpu.FragmentState[
                __lifetime_of(shader_module),
                ImmutableStaticLifetime,
                __lifetime_of(targets),
            ](
                module=shader_module,
                entry_point="fs_main".as_string_slice(),
                targets=targets,
            ),
            primitive=wgpu.PrimitiveState(
                topology=wgpu.PrimitiveTopology.triangle_list,
            ),
            multisample=wgpu.MultisampleState(),
            layout=None,
            depth_stencil=None,
        )
    )

    if not pipeline._handle:
        raise Error("failed to get render pipeline")

    while not window.should_close():
        glfw.poll_events()
        with surface.get_current_texture() as surface_tex:
            if (
                surface_tex.status
                != wgpu.SurfaceGetCurrentTextureStatus.success
            ):
                raise Error("failed to get surface tex")
            target_view = surface_tex.texture[].create_view(
                format=surface_tex.texture[].get_format(),
                dimension=wgpu.TextureViewDimension.d2,
                base_mip_level=0,
                mip_level_count=1,
                base_array_layer=0,
                array_layer_count=1,
                aspect=wgpu.TextureAspect.all,
            )
            encoder = device.create_command_encoder()
            color_attachments = List[wgpu.RenderPassColorAttachment](
                wgpu.RenderPassColorAttachment(
                    view=target_view,
                    load_op=wgpu.LoadOp.clear,
                    store_op=wgpu.StoreOp.store,
                    clear_value=wgpu.Color(0.9, 0.1, 0.2, 1.0),
                )
            )

            rp = encoder.begin_render_pass(color_attachments=color_attachments)
            rp.set_pipeline(pipeline)
            rp.draw(3, 1, 0, 0)
            rp.end()

            command = encoder.finish()

            queue.submit(command)
            surface.present()

    glfw.terminate()
