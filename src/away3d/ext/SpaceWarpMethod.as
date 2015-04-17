package away3d.ext
{
import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.managers.Stage3DProxy;
import away3d.materials.compilation.ShaderRegisterCache;
import away3d.materials.compilation.ShaderRegisterElement;
import away3d.materials.methods.EffectMethodBase;
import away3d.materials.methods.MethodVO;
import flash.geom.Vector3D;

import flash.geom.Matrix3D;

use namespace arcane;

public class SpaceWarpMethod extends EffectMethodBase
{
	public var elevate:Number;
	public var turn:Number;

	public var camera3d:Camera3D;
	private var buffer:Matrix3D = new Matrix3D();

	public function SpaceWarpMethod(elevate:Number, turn:Number, camera3d:Camera3D)
	{
		super();

		this.elevate = elevate;
		this.turn = turn;
		this.camera3d = camera3d;


	}


	override arcane function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
	{
		return "";
	}

	arcane override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
	{
		var data:Vector.<Number> = vo.vertexData;
		var index:int = vo.vertexConstantsIndex;
		data[index + 0] = turn;
		data[index + 1] = elevate;
		data[index + 2] = 0;
		data[index + 3] = 0;

		buffer.copyFrom(camera3d.viewProjection);
		buffer.copyRawDataTo(data, index + 4, true);

		buffer.invert();
		buffer.copyRawDataTo(data, index + 20, true);
	}

	
	public function transform(vertex:Vector3D):Vector3D
	{
		var out:Vector3D = vertex.clone();
		out.x += out.z * out.z * turn;
		out.y += out.z * out.z * elevate;
		return out;
	}

	override arcane function getVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String
	{
		var data:ShaderRegisterElement = regCache.getFreeVertexConstant();
		vo.vertexConstantsIndex = data.index * 4;
		var m0:ShaderRegisterElement = regCache.getFreeVertexConstant();
		var m1:ShaderRegisterElement = regCache.getFreeVertexConstant();
		var m2:ShaderRegisterElement = regCache.getFreeVertexConstant();
		var m3:ShaderRegisterElement = regCache.getFreeVertexConstant();

		var im0:ShaderRegisterElement = regCache.getFreeVertexConstant();
		var im1:ShaderRegisterElement = regCache.getFreeVertexConstant();
		var im2:ShaderRegisterElement = regCache.getFreeVertexConstant();
		var im3:ShaderRegisterElement = regCache.getFreeVertexConstant();

		var temp:ShaderRegisterElement = regCache.getFreeVertexVectorTemp();
		regCache.addVertexTempUsages(temp, 1);
		var temp2:ShaderRegisterElement = regCache.getFreeVertexSingleTemp();
		regCache.addVertexTempUsages(temp2, 1);

		regCache.removeVertexTempUsage(temp);
		regCache.removeVertexTempUsage(temp2);

		return ""
				//temp = projection(vertex)
			   + "m44 " + temp + ", " +  _sharedRegisters.localPosition + ", vc0 \n"
				//temp = unproject temp by inverseViewTransform
			   + "m44 " + temp + ", " + temp + ", " + im0 + "\n"

				//calc turn
			   + "mul " + temp2 + ", " + temp + ".z, " + temp + ".z\n"
			   + "mul " + temp2 + ", " + data + ".x, " + temp2 + "\n"
			   + "add " + temp +  ".x, " + temp + ".x, " + temp2 + "\n"


				//calc elevation
			   + "mul " + temp2 + ", " + temp + ".z, " + temp + ".z\n"
			   + "mul " + temp2 + ", " + data + ".y, " + temp2 + "\n"
			   + "add " + temp +  ".y, " + temp + ".y, " + temp2 + "\n"
	
		       + "m44 op, " + temp + ", " + m0;
			 //  "mov " + temp + ".z, vt0.z\n" +
			 //  "mov " + temp + ".w, vt0.w\n" +

			 //  "m44 " + temp + ", " + temp + ", vc0\n" +

			 //  "mov op, " + temp + "\n"

			  // + "m44 op, vt0, vc0\n";
	}
}
}
