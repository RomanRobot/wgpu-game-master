from wgpu import glfw
import wgpu._cffi as wgpu
import sys
from collections import Optional


fn request_adapter_sync(
    instance: wgpu.WGPUInstance, surface: Optional[wgpu.WGPUSurface] = None
) -> wgpu.WGPUAdapter:
    fn req_adapter(
        status: wgpu.RequestAdapterStatus,
        adapter: wgpu.WGPUAdapter,
        message: UnsafePointer[Int8],
        user_data: UnsafePointer[NoneType],
    ):
        u_data = user_data.bitcast[Tuple[wgpu.WGPUAdapter, Bool]]()
        u_data[][0] = adapter
        u_data[][1] = True

    adapter_user_data = (wgpu.WGPUAdapter(), False)

    wgpu.instance_request_adapter(
        instance,
        req_adapter,
        UnsafePointer.address_of(adapter_user_data).bitcast[NoneType](),
    )
    debug_assert(adapter_user_data[1], "adapter request did not finish")
    adapter = adapter_user_data[0]
    return adapter


fn request_device_sync(adapter: wgpu.WGPUAdapter) -> wgpu.WGPUDevice:
    fn req_device(
        status: wgpu.RequestDeviceStatus,
        device: wgpu.WGPUDevice,
        message: UnsafePointer[Int8],
        user_data: UnsafePointer[NoneType],
    ):
        u_data = user_data.bitcast[Tuple[wgpu.WGPUDevice, Bool]]()
        u_data[][0] = device
        u_data[][1] = True

    device_user_data = (wgpu.WGPUDevice(), False)
    wgpu.adapter_request_device(
        adapter,
        req_device,
        UnsafePointer.address_of(device_user_data).bitcast[NoneType](),
    )
    debug_assert(device_user_data[1], "device request did not finish")
    device = device_user_data[0]
    return device


def main():
    glfw.init()
    window = glfw.Window(640, 480, "Hello, WebGPU")
    instance = wgpu.create_instance()
    if not instance:
        raise Error("failed to get instance")

    surface = glfw_get_wgpu_surface(instance, window)
    if not surface:
        raise Error("failed to get surface")

    adapter = request_adapter_sync(instance, surface)

    if not adapter:
        raise Error("failed to get adapter")

    device = request_device_sync(adapter)
    if not device:
        raise Error("failed to get device")

    queue = wgpu.device_get_queue(device)
    if not queue:
        raise Error("failed to get queue")

    surface_capabilities = wgpu.WGPUSurfaceCapabilities()
    wgpu.surface_get_capabilities(surface, adapter, surface_capabilities)
    surface_format = surface_capabilities.formats[0]

    wgsl_shader = wgpu.WGPUShaderModuleWgslDescriptor(
        chain=wgpu.ChainedStruct(
            s_type=wgpu.SType.shader_module_wgsl_descriptor
        ),
        code="""
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
            """.unsafe_cstr_ptr(),
    )
    shader_module = wgpu.device_create_shader_module(
        device,
        wgpu.WGPUShaderModuleDescriptor(
            next_in_chain=UnsafePointer.address_of(wgsl_shader).bitcast[
                wgpu.ChainedStruct
            ]()
        ),
    )

    if not shader_module:
        raise Error("failed to create shader module")

    _ = wgsl_shader^

    blend_state = wgpu.WGPUBlendState(
        color=wgpu.WGPUBlendComponent(
            src_factor=wgpu.BlendFactor.src_alpha,
            dst_factor=wgpu.BlendFactor.one_minus_src_alpha,
            operation=wgpu.BlendOperation.add,
        ),
        alpha=wgpu.WGPUBlendComponent(
            src_factor=wgpu.BlendFactor.zero,
            dst_factor=wgpu.BlendFactor.one,
            operation=wgpu.BlendOperation.add,
        ),
    )
    color_target = wgpu.WGPUColorTargetState(
        blend=UnsafePointer.address_of(blend_state),
        format=surface_format,
        write_mask=wgpu.ColorWriteMask.all,
    )

    fragment_state = wgpu.WGPUFragmentState(
        module=shader_module,
        entry_point="fs_main".unsafe_cstr_ptr(),
        target_count=1,
        targets=UnsafePointer.address_of(color_target),
    )
    pipeline_layout = wgpu.device_create_pipeline_layout(
        device,
        wgpu.WGPUPipelineLayoutDescriptor(
            label="pipeline_layout".unsafe_cstr_ptr()
        ),
    )

    pipeline = wgpu.device_create_render_pipeline(
        device,
        wgpu.WGPURenderPipelineDescriptor(
            label="render_pipeline".unsafe_cstr_ptr(),
            layout=pipeline_layout,
            vertex=wgpu.WGPUVertexState(
                module=shader_module,
                entry_point="vs_main".unsafe_cstr_ptr(),
            ),
            primitive=wgpu.WGPUPrimitiveState(
                topology=wgpu.PrimitiveTopology.triangle_list,
            ),
            fragment=UnsafePointer.address_of(fragment_state),
            multisample=wgpu.WGPUMultisampleState(count=1, mask=0xFFFFFFFF),
        ),
    )
    if not pipeline:
        raise Error("failed to get render pipeline")

    _ = fragment_state^
    _ = blend_state^
    _ = color_target^

    wgpu.surface_configure(
        surface,
        wgpu.WGPUSurfaceConfiguration(
            # Configuration of the textures created for the underlying swap chain
            width=640,
            height=480,
            usage=wgpu.TextureUsage.render_attachment,
            format=surface_format,
            device=device,
            alpha_mode=surface_capabilities.alpha_modes[],
            present_mode=wgpu.PresentMode.fifo,
        ),
    )

    while not window.should_close():
        glfw.poll_events()
        surface_tex = wgpu.WGPUSurfaceTexture()
        wgpu.surface_get_current_texture(surface, surface_tex)
        if surface_tex.status == wgpu.SurfaceGetCurrentTextureStatus.success:
            pass
        else:
            raise Error("unsuccessful surface texture")
        frame = wgpu.texture_create_view(surface_tex.texture)

        encoder = wgpu.device_create_command_encoder(device)
        color_attachment = wgpu.WGPURenderPassColorAttachment(
            view=frame,
            load_op=wgpu.LoadOp.clear,
            store_op=wgpu.StoreOp.store,
            clear_value=wgpu.WGPUColor(0.9, 0.1, 0.2, 1.0),
            depth_slice=wgpu.DEPTH_SLICE_UNDEFINED,
        )
        rp = wgpu.command_encoder_begin_render_pass(
            encoder,
            wgpu.WGPURenderPassDescriptor(
                color_attachment_count=1,
                color_attachments=UnsafePointer.address_of(color_attachment),
            ),
        )
        wgpu.render_pass_encoder_set_pipeline(rp, pipeline)
        wgpu.render_pass_encoder_draw(rp, 3, 1, 0, 0)
        wgpu.render_pass_encoder_end(rp)
        wgpu.render_pass_encoder_release(rp)

        command = wgpu.command_encoder_finish(encoder)

        wgpu.queue_submit(queue, 1, UnsafePointer.address_of(command))
        wgpu.surface_present(surface)
        wgpu.command_buffer_release(command)
        wgpu.command_encoder_release(encoder)
        wgpu.texture_view_release(frame)
        wgpu.texture_release(surface_tex.texture)
        _ = color_attachment^

    wgpu.render_pipeline_release(pipeline)
    wgpu.pipeline_layout_release(pipeline_layout)
    wgpu.shader_module_release(shader_module)
    wgpu.surface_capabilities_free_members(surface_capabilities)
    wgpu.surface_unconfigure(surface)
    wgpu.queue_release(queue)
    wgpu.device_release(device)
    wgpu.adapter_release(adapter)
    wgpu.surface_release(surface)
    _ = window^
    wgpu.instance_release(instance)
    glfw.terminate()


fn glfw_get_wgpu_surface(
    instance: wgpu.WGPUInstance, window: glfw.Window
) -> wgpu.WGPUSurface:
    platform = glfw.get_platform()
    if platform == glfw.Platform.cocoa:
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
        ns_window = window.get_cocoa_window().bitcast[NoneType]()
        getter = sel("contentView")
        content_view = objc_msg_send(ns_window, getter)
        set_wants_layer = sel("setWantsLayer:")
        set_layer = sel("setLayer:")
        objc_msg_send_bool(content_view, set_wants_layer, True)
        objc_msg_send_ptr(content_view, set_layer, metal_layer)
        from_metal_layer = wgpu.WGPUSurfaceDescriptorFromMetalLayer(
            chain=wgpu.ChainedStruct(
                s_type=wgpu.SType.surface_descriptor_from_metal_layer,
            ),
            layer=metal_layer,
        )
        descriptor = wgpu.WGPUSurfaceDescriptor(
            next_in_chain=UnsafePointer.address_of(from_metal_layer).bitcast[
                wgpu.ChainedStruct
            ](),
            label=UnsafePointer[Int8](),
        )
        surf = wgpu.instance_create_surface(instance, descriptor)
        _ = from_metal_layer^  # keep layer alive
        return surf
    # elif platform == glfw.Platform.x11:
    #     pass
    # elif platform == glfw.Platform.wayland:
    #     pass
    else:
        return wgpu.WGPUSurface()
