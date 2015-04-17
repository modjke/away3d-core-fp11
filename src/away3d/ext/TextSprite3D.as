package away3d.ext
{
	import away3d.core.math.Matrix3DUtils;
	import away3d.entities.Sprite3D;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.TextureUtils;
	import bmfontrenderer.BMFont;
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	public class TextSprite3D extends Sprite3D 
	{
		
		private var textureMaterial:TextureMaterial;
		private var bitmapTexture:BitmapTexture;
		
		public function get alpha():Number 
		{
			return textureMaterial.alpha;
		}
		
		public function set alpha(value:Number):void
		{
			textureMaterial.alpha = value;
		}
		
		public function TextSprite3D(text:String, font:BMFont) 
		{
			var size:Point = font.measureString(text);
			var bitmapData:BitmapData = new BitmapData(size.x, size.y, true, 0x00000000);
			font.drawString(bitmapData, 0, 0, text);
			
			var scaleU:Number = 1.0;
			
			if (!TextureUtils.isBitmapDataValid(bitmapData))
			{
				var temp:BitmapData = bitmapData;
				bitmapData = new BitmapData(TextureUtils.getBestPowerOf2(size.x), TextureUtils.getBestPowerOf2(size.y), true, 0x00000000);
				trace(bitmapData.width, bitmapData.height);
				
				var matrix:Matrix = new Matrix();
				matrix.scale(bitmapData.width / temp.width, bitmapData.height / temp.height);
				bitmapData.draw(temp, matrix, null, null, null, true);
			}
			
			bitmapTexture = new BitmapTexture(bitmapData, false);
			
			textureMaterial = new TextureMaterial(bitmapTexture, true, false, false);
			textureMaterial.alphaBlending = true;
			textureMaterial.alphaPremultiplied = true;
			
			super(textureMaterial, size.x, size.y);
			
			
		}
		
	}

}