package away3d.ext
{
	import away3d.containers.ObjectContainer3D;
	public class Mouse3DUtils 
	{
		
		/**
		 * Sets mouseEnabled for object and mouseChildren for it's parent containers		 
		 * @param	object
		 * @param	mouseEnabled
		 * @param	mouseChildren
		 */
		public static function setMouseEnabled(object:ObjectContainer3D, mouseEnabled:Boolean, mouseChildren:Boolean = false):void
		{
			object.mouseChildren = mouseChildren;
			object.mouseEnabled = mouseEnabled;
			
			if (object.parent != null)
				setMouseEnabled(object.parent, mouseEnabled, mouseEnabled); //NOT A TYPO!
		}
		
	}
}