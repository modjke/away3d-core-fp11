package away3d.ext
{
import away3d.containers.ObjectContainer3D;
import away3d.controllers.ControllerBase;
import away3d.core.math.Matrix3DUtils;
import away3d.entities.Entity;
import away3d.events.Object3DEvent;

import flash.geom.Vector3D;

public class SpringControllerExt extends ControllerBase
{
	private var _velocity:Vector3D;
	private var _dv:Vector3D;
	private var _stretch:Vector3D;
	private var _force:Vector3D;
	private var _acceleration:Vector3D;
	private var _desiredPosition:Vector3D;
	private var _pos:Vector3D = new Vector3D();
	private var _upAxis:Vector3D = Vector3D.Y_AXIS;
	private var _lookAtObject:ObjectContainer3D;


	/**
	 * Stiffness of the spring, how hard is it to extend. The higher it is, the more "fixed" the cam will be.
	 * A number between 1 and 20 is recommended.
	 */
	public var stiffness:Number;

	/**
	 * Damping is the spring internal friction, or how much it resists the "boinggggg" effect. Too high and you'll lose it!
	 * A number between 1 and 20 is recommended.
	 */
	public var damping:Number;

	/**
	 * Mass of the camera, if over 120 and it'll be very heavy to move.
	 */
	public var mass:Number;

	/**
	 * Offset of spring center from target in target object space, ie: Where the camera should ideally be in the target object space.
	 */
	public var positionOffset:Vector3D = new Vector3D(0, 500, -1000);

	/**
	 * Offset of targetObject position
	 */
	public var targetOffset:Vector3D = new Vector3D(0, 0, 0);

	public function SpringControllerExt(targetObject:Entity = null, lookAtObject:ObjectContainer3D = null, stiffness:Number = 1, mass:Number = 40, damping:Number = 4)
	{
		super(targetObject);

		this.lookAtObject = lookAtObject;
		this.stiffness = stiffness;
		this.damping = damping;
		this.mass = mass;

		_velocity = new Vector3D();
		_dv = new Vector3D();
		_stretch = new Vector3D();
		_force = new Vector3D();
		_acceleration = new Vector3D();
		_desiredPosition = new Vector3D();

	}

	/**
	 * The 3d object that the target looks at.
	 */
	public function get lookAtObject():ObjectContainer3D
	{
		return _lookAtObject;
	}

	public function set lookAtObject(val:ObjectContainer3D):void
	{
		if (_lookAtObject == val)
			return;

		if (_lookAtObject)
			_lookAtObject.removeEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);

		_lookAtObject = val;

		if (_lookAtObject)
			_lookAtObject.addEventListener(Object3DEvent.SCENETRANSFORM_CHANGED, onLookAtObjectChanged);

		notifyUpdate();
	}

	private function onLookAtObjectChanged(event:Object3DEvent):void
	{
		notifyUpdate();
	}


	public function resetPosition():void
	{
		var offs:Vector3D;

		if (!_lookAtObject || !_targetObject)
			return;

		offs = _lookAtObject.transform.deltaTransformVector(positionOffset);
		_targetObject.x = _lookAtObject.scenePosition.x + offs.x;
		_targetObject.y = _lookAtObject.scenePosition.y + offs.y;
		_targetObject.z = _lookAtObject.scenePosition.z + offs.z;

		_lookAtTarget();
	}

	public override function update(interpolate:Boolean = true):void
	{
		interpolate = interpolate; // prevents unused warning

		var offs:Vector3D;

		if (!_lookAtObject || !_targetObject)
			return;

		offs = _lookAtObject.transform.deltaTransformVector(positionOffset);
		_desiredPosition.x = _lookAtObject.scenePosition.x + offs.x;
		_desiredPosition.y = _lookAtObject.scenePosition.y + offs.y;
		_desiredPosition.z = _lookAtObject.scenePosition.z + offs.z;

		_stretch.x = _targetObject.x - _desiredPosition.x;
		_stretch.y = _targetObject.y - _desiredPosition.y;
		_stretch.z = _targetObject.z - _desiredPosition.z;
		_stretch.scaleBy(-stiffness);

		_dv.copyFrom(_velocity);
		_dv.scaleBy(damping);

		_force.x = _stretch.x - _dv.x;
		_force.y = _stretch.y - _dv.y;
		_force.z = _stretch.z - _dv.z;

		_acceleration.copyFrom(_force);
		_acceleration.scaleBy(1/mass);

		_velocity.x += _acceleration.x;
		_velocity.y += _acceleration.y;
		_velocity.z += _acceleration.z;

		_targetObject.x += _velocity.x;
		_targetObject.y += _velocity.y;
		_targetObject.z += _velocity.z;

		_lookAtTarget();
	}

	private function _lookAtTarget():void
	{
		if (_targetObject) {
			 if (_lookAtObject) {
				if(_targetObject.parent && _lookAtObject.parent) {
					if(_targetObject.parent != _lookAtObject.parent) {// different spaces
						_pos.x = _lookAtObject.scenePosition.x + targetOffset.x;
						_pos.y = _lookAtObject.scenePosition.y + targetOffset.y;
						_pos.z = _lookAtObject.scenePosition.z + targetOffset.z;
						Matrix3DUtils.transformVector(_targetObject.parent.inverseSceneTransform, _pos, _pos);
					}else{//one parent
						Matrix3DUtils.getTranslation(_lookAtObject.transform, _pos);
					}
				}else if(_lookAtObject.scene){
					_pos.x = _lookAtObject.scenePosition.x + targetOffset.x;
					_pos.y = _lookAtObject.scenePosition.y + targetOffset.y;
					_pos.z = _lookAtObject.scenePosition.z + targetOffset.z;
				}else{
					Matrix3DUtils.getTranslation(_lookAtObject.transform, _pos);
				}
				_targetObject.lookAt(_pos, _upAxis);
			}
		}
	}

}
}
