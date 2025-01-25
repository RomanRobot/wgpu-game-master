alias Vec4 = SIMD[DType.float32, 4]

# def vec4_zero() -> Vec4:
#     """
#     Returns the zero vector (0, 0, 0, 0).
#     """
#     return Vec4(0.0, 0.0, 0.0, 0.0)

# def vec4_one() -> Vec4:
#     """
#     Returns the vector (1, 1, 1, 1).
#     """
#     return Vec4(1.0, 1.0, 1.0, 1.0)

# def vec4_unit_x() -> Vec4:
#     """
#     Returns the unit vector along the X-axis (1, 0, 0, 0).
#     """
#     return Vec4(1.0, 0.0, 0.0, 0.0)

# def vec4_unit_y() -> Vec4:
#     """
#     Returns the unit vector along the Y-axis (0, 1, 0, 0).
#     """
#     return Vec4(0.0, 1.0, 0.0, 0.0)

# def vec4_unit_z() -> Vec4:
#     """
#     Returns the unit vector along the Z-axis (0, 0, 1, 0).
#     """
#     return Vec4(0.0, 0.0, 1.0, 0.0)

# def vec4_unit_w() -> Vec4:
#     """
#     Returns the unit vector along the W-axis (0, 0, 0, 1).
#     """
#     return Vec4(0.0, 0.0, 0.0, 1.0)

# def vec4_add(v1: Vec4, v2: Vec4) -> Vec4:
#     """
#     Adds two vectors component-wise.
#     """
#     return Vec4(v1 + v2)

# def vec4_sub(v1: Vec4, v2: Vec4) -> Vec4:
#     """
#     Subtracts two vectors component-wise.
#     """
#     return Vec4(v1 - v2)

# def vec4_mul(v: Vec4, scalar: Float32) -> Vec4:
#     """
#     Multiplies the vector by a scalar.
#     """
#     return Vec4(v * scalar)

# def vec4_div(v: Vec4, scalar: Float32) -> Vec4:
#     """
#     Divides the vector by a scalar.
#     """
#     assert scalar != 0.0, "Division by zero is not allowed."
#     return Vec4(v / scalar)

# def vec4_dot(v1: Vec4, v2: Vec4) -> Float32:
#     """
#     Computes the dot product of two vectors.
#     """
#     return (v1 * v2).sum()

# def vec4_magnitude(v: Vec4) -> Float32:
#     """
#     Computes the magnitude (length) of the vector.
#     """
#     return (v * v).sum().sqrt()

# def vec4_normalize(v: Vec4) -> Vec4:
#     """
#     Normalizes the vector (makes it unit length).
#     """
#     mag = vec4_magnitude(v)
#     assert mag != 0.0, "Cannot normalize a zero vector."
#     return vec4_div(v, mag)

# def vec4_to_tuple(v: Vec4) -> (Float32, Float32, Float32, Float32):
#     """
#     Converts the vector to a tuple.
#     """
#     return (v[0], v[1], v[2], v[3])

# def vec4_distance_to(v1: Vec4, v2: Vec4) -> Float32:
#     """
#     Computes the distance between this vector and another vector.
#     """
#     return vec4_magnitude(vec4_sub(v1, v2))

# def vec4_lerp(v1: Vec4, v2: Vec4, t: Float32) -> Vec4:
#     """
#     Linearly interpolates between this vector and another vector by `t`.
#     """
#     return vec4_add(vec4_mul(v1, 1.0 - t), vec4_mul(v2, t))
