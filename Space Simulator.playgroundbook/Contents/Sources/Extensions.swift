import SceneKit

extension SCNVector3 {
    var vector4: SCNVector4 {
        return SCNVector4Make(self.x, self.y, self.z, 0.0)
    }
}

extension SCNVector4 {
    var vector3: SCNVector3 {
        return SCNVector3Make(self.x, self.y, self.z)
    }
}

func SCNMatrix4MultV(pM: SCNMatrix4, pV: SCNVector4) -> SCNVector4 {
    let r = SCNVector4.init(
        x: pM.m11 * pV.x + pM.m12 * pV.y + pM.m13 * pV.z + pM.m14 * pV.w,
        y: pM.m21 * pV.x + pM.m22 * pV.y + pM.m23 * pV.z + pM.m24 * pV.w,
        z: pM.m31 * pV.x + pM.m32 * pV.y + pM.m33 * pV.z + pM.m34 * pV.w,
        w: pM.m41 * pV.x + pM.m42 * pV.y + pM.m43 * pV.z + pM.m44 * pV.w
    )
    return r;
}
