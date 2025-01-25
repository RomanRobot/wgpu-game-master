from math import tan, cos, sin

alias Mat4 = SIMD[DType.float32, 16]

def mat4_zero() -> Mat4:
    """
    Returns a 4x4 matrix filled with zeros.
    """
    return Mat4(0.0)

def mat4_identity() -> Mat4:
    """
    Returns the identity matrix (diagonal of 1s).
    """
    return Mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    )

def mat4_translation(tx: Float32, ty: Float32, tz: Float32) -> Mat4:
    """
    Returns a translation matrix.
    """
    return Mat4(
        1.0, 0.0, 0.0, tx,
        0.0, 1.0, 0.0, ty,
        0.0, 0.0, 1.0, tz,
        0.0, 0.0, 0.0, 1.0
    )

def mat4_scaling(sx: Float32, sy: Float32, sz: Float32) -> Mat4:
    """
    Returns a scaling matrix.
    """
    return Mat4(
        sx, 0.0, 0.0, 0.0,
        0.0, sy, 0.0, 0.0,
        0.0, 0.0, sz, 0.0,
        0.0, 0.0, 0.0, 1.0
    )

def mat4_rotation_x(angle: Float32) -> Mat4:
    """
    Returns a rotation matrix around the X-axis.
    """
    c = cos(angle)
    s = sin(angle)
    return Mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, c, -s, 0.0,
        0.0, s, c, 0.0,
        0.0, 0.0, 0.0, 1.0
    )

def mat4_rotation_y(angle: Float32) -> Mat4:
    """
    Returns a rotation matrix around the Y-axis.
    """
    c = cos(angle)
    s = sin(angle)
    return Mat4(
        c, 0.0, s, 0.0,
        0.0, 1.0, 0.0, 0.0,
        -s, 0.0, c, 0.0,
        0.0, 0.0, 0.0, 1.0
    )

def mat4_rotation_z(angle: Float32) -> Mat4:
    """
    Returns a rotation matrix around the Z-axis.
    """
    c = cos(angle)
    s = sin(angle)
    return Mat4(
        c, -s, 0.0, 0.0,
        s, c, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    )

def mat4_perspective(fov: Float32, aspect: Float32, near: Float32, far: Float32) -> Mat4:
    """
    Returns a perspective projection matrix.
    """
    f = 1.0 / tan(fov / 2.0)
    return Mat4(
        f / aspect, 0.0, 0.0, 0.0,
        0.0, f, 0.0, 0.0,
        0.0, 0.0, (far + near) / (near - far), (2.0 * far * near) / (near - far),
        0.0, 0.0, -1.0, 0.0
    )

def mat4_mul(a: Mat4, b: Mat4) -> Mat4:
    """
    Multiplies two matrices using SIMD.
    """
    result = Mat4(0.0)
    for j in range(4):
        for i in range(4):
            var sum_value: Float32 = 0.0
            for k in range(4):
                sum_value += a[i * 4 + k] * b[k * 4 + j]
            result[i * 4 + j] = sum_value
    return result

def mat4_transform_vector(m: Mat4, v: SIMD[DType.float32, 4]) -> SIMD[DType.float32, 4]:
    """
    Transforms a 4D vector (x, y, z, w) using the matrix.
    """
    result = SIMD[DType.float32, 4](0.0)
    for i in range(4):
        result[i] = sum(m[i * 4 + j] * v[j] for j in range(4))
    return result
