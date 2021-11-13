# Module math.matrix4
_a matrix4 class_

## Functions

### class:matrix4(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)

_constructor for matrix4_

**Arguments**
  - m11,m12,m13,m14 ..., m44:`number` the initial (row major)

---

### class:clone()

_returns a copy of the matrix4_

**Returns**
  - `math.matrix4` new matrix4 copied from self

---

### class.copy(a, b)

_copies matrix4 values from another matrix4_

**Arguments**
  - a:`math.matrix4` the matrix to copy into
  - b:`math.matrix4` the matrix to copy from

**Returns**
  - `math.matrix4` matrix `a` copied from `b`

---

### class.__add(a, b)

_add operator for matrix4 (a + b)_

**Arguments**
  - a:`math.matrix4` or `number`
  - b:`math.matrix4` or `number`

**Returns**
  - `math.matrix4` new resulting matrix4

---

### class.__sub(a, b)

_subtract operator for matrix4 (a - b)_

**Arguments**
  - a:`math.matrix4` or `number`
  - b:`math.matrix4` or `number`

**Returns**
  - `math.matrix4` new resulting matrix4

---

### class.__mul(a, b)

_multiply operator for matrix4 (a * b)_

**Arguments**
  - a:`math.matrix4` or `number`
  - b:`math.matrix4` or `number`

**Returns**
  - `math.matrix4` new resulting matrix4

---

### class.__div(a, b)

_divide operator for matrix4 (a / b)_

**Arguments**
  - a:`math.matrix4` or `number`
  - b:`math.matrix4` or `number`

**Returns**
  - `math.matrix4` new resulting matrix4

---

### class.__mod()

_modulus not supported (a % b)_

**Returns**
  - error: "modulus not supported"

---

### class.__unm(a)

_unary minus operator for matrix4 (-a)_

**Arguments**
  - a:`math.matrix4`

**Returns**
  - `math.matrix4` matrix `a` with negated values

---

### class.__eq(a, b)

_equality operator for matrix4 (a == b)_

**Arguments**
  - a:`math.matrix4`
  - b:`math.matrix4`

**Returns**
  - `boolean` `true` if a and b are equal, else `false`

---

### class.__pow(a, b)

_involution (power) operator for matrix4 (a ^ b)_

**Arguments**
  - a:`math.matrix4`
  - b:`number`

> Note: only positive integers are supported 

**Returns**
  - `math.matrix4` new resulting matrix4

---

### class.__len(a)

_# operator for matrix4 (returns length)_

**Arguments**
  - a:`math.matrix4`

**Returns**
  - `number` 4

---

### class.identity(a)

_sets the matrix4 to an identity matrix_

**Arguments**
  - a:`math.matrix4`

**Returns**
  - `math.matrix4` matrix `a` as identity matrix

---

### class.scale(a, x, y, z)

_sets the matrix4 to an scaled matrix_

**Arguments**
  - a:`math.matrix`
  - x:`number` x scale
  - y:`number` y scale
  - z:`number` z scale

**Returns**
  - `math.matrix4` matrix `a` as scaled matrix

---

### class.set(a, m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)

_sets the matrix4 with given values_

**Arguments**
  - a:`math.matrix`
  - 1,2,3 ..., 16:`number` (row major)

> Note: values which are not specified are set to 0.0 

**Returns**
  - `math.matrix4` matrix `a` with new values

---

### class.rotate(a, x, y, z)

_sets the matrix4 to a rotation matrix_

**Arguments**
  - a:`math.matrix`
  - x:'number' rotation on x axis in radians
  - y:'number' rotation on y axis in radians
  - z:'number' rotation on z axis in radians

**Returns**
  - `math.matrix4` matrix `a` as rotation matrix

---

### class.rotateX(a, x)

_sets the matrix4 to a rotation matrix along the x axis_

**Arguments**
  - a:`math.matrix`
  - x:'number' rotation on x axis in radians

**Returns**
  - `math.matrix4` matrix `a` as rotation matrix along the x axis

---

### class.rotateY(a, y)

_sets the matrix4 to a rotation matrix along the y axis_

**Arguments**
  - a:`math.matrix`
  - y:'number' rotation on y axis in radians

**Returns**
  - `math.matrix4` matrix `a` as rotation matrix along the y axis

---

### class.rotateZ(a, z)

_sets the matrix4 to a rotation matrix along the z axis_

**Arguments**
  - a:`math.matrix`
  - z:'number' rotation on z axis in radians

**Returns**
  - `math.matrix4` matrix `a` as rotation matrix along the z axis

---

### class.translate(a, x, y, z)

_sets the matrix4 to a translation matrix given x,y,z_

**Arguments**
  - a:`math.matrix`
  - x:'number' the x translation
  - y:'number' the y translation
  - z:'number' the z translation

**Returns**
  - `math.matrix4` matrix `a` as translation matrix x,y,z

---

### class.transform(a, sx, sy, sz, px, py, pz, rx, ry, rz)

_sets the matrix4 to a transformation matrix_

**Arguments**
  - a:`math.matrix`
  - sx:'number' the x scale
  - sy:'number' the y scale
  - sz:'number' the z scale
  - px:'number' the x translation
  - py:'number' the y translation
  - pz:'number' the z translation
  - rx:'number' rotation on x axis in radians
  - ry:'number' rotation on y axis in radians
  - rz:'number' rotation on z axis in radians

**Returns**
  - `math.matrix4` matrix `a` as transformation matrix

---

### class.perspective(a, fov, aspect, near, far)

_sets the matrix4 to a perspective matrix_

**Arguments**
  - a:`math.matrix`
  - fov:'number' the field of view in radians
  - aspect:'number' the aspect ratio of the screen
  - near:'number' the near clipping plane
  - far:'number' the far clipping plane

**Returns**
  - `math.matrix4` matrix `a` as perspective matrix

---

### class.inverse(a)

_inverses the matrix4_

**Arguments**
  - a:`math.matrix`

**Returns**
  - `math.matrix4` matrix `a` as inversed matrix

---

### class.transpose(a)

_transposes the matrix4_

**Arguments**
  - a:`math.matrix`

**Returns**
  - `math.matrix4` matrix `a` tranposed

---

### class.getLeft(a)

_gets the left direction of the matrix_

**Arguments**
  - a:`math.matrix`

**Returns**
  - x `number`, y `number`, z `number`

---

### class.getUp(a)

_gets the up direction of the matrix_

**Arguments**
  - a:`math.matrix`

**Returns**
  - x `number`, y `number`, z `number`

---

### class.getForward(a)

_gets the forward direction of the matrix_

**Arguments**
  - a:`math.matrix`

**Returns**
  - x `number`, y `number`, z `number`

---

### class.getPosition(a)

_gets the position of the matrix_

**Arguments**
  - a:`math.matrix`

**Returns**
  - x `number`, y `number`, z `number`

---

### class.tostring(a, decimals)

_returns a string of the matrix4_

**Arguments**
  - **a**:`math.matrix`
  - **decimals**:`number` the number of decimals to display, default is 2

**Returns**
  - `string` "1.00, 0.00, 0.00, 0.00<br />,0.00, 1.00, 0.00, 0.00<br />,0.00, 0.00, 1.00, 0.00<br />,0.00, 0.00, 0.00, 1.00"

---

### class.__tostring(a)

_returns a string of the matrix4 for tostring(`math.matrix4`) to 2 decimal places_

**Returns**
  - `string` "1.00, 0.00, 0.00, 0.00<br />,0.00, 1.00, 0.00, 0.00<br />,0.00, 0.00, 1.00, 0.00<br />,0.00, 0.00, 0.00, 1.00"

---

_Generated by luaprettydoc 0.1.0 / 2021-11-13 03:25:27_
