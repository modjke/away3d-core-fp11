package away3d.core.base
{
	import away3d.core.managers.Stage3DProxy;

	import flash.display3D.IndexBuffer3D;

	public interface ISubGeometry
	{
		/**
		 * The total amount of vertices in the SubGeometry.
		 */
		function get numVertices() : uint;

		/**
		 * The amount of triangles that comprise the IRenderable geometry.
		 */
		function get numTriangles() : uint;

		/**
		 * The number of data elements in the buffers per vertex.
		 * This always applies to vertices, normals and tangents.
		 */
		function get vertexStride() : uint;

		/**
		 * Assigns the attribute stream for vertex positions.
		 * @param index The attribute stream index for the vertex shader
		 * @param stage3DProxy The Stage3DProxy to assign the stream to
		 */
		function activateVertexBuffer(index : int, stage3DProxy : Stage3DProxy) : void;


		/**
		 * Assigns the attribute stream for UV coordinates
		 * @param index The attribute stream index for the vertex shader
		 * @param stage3DProxy The Stage3DProxy to assign the stream to
		 */
		function activateUVBuffer(index : int, stage3DProxy : Stage3DProxy) : void;

		/**
		 * Assigns the attribute stream for a secondary set of UV coordinates
		 * @param index The attribute stream index for the vertex shader
		 * @param stage3DProxy The Stage3DProxy to assign the stream to
		 */
		function activateSecondaryUVBuffer(index : int, stage3DProxy : Stage3DProxy) : void;

		/**
		 * Assigns the attribute stream for vertex normals
		 * @param index The attribute stream index for the vertex shader
		 * @param stage3DProxy The Stage3DProxy to assign the stream to
		 */
		function activateVertexNormalBuffer(index : int, stage3DProxy : Stage3DProxy) : void;

		/**
		 * Assigns the attribute stream for vertex tangents
		 * @param index The attribute stream index for the vertex shader
		 * @param stage3DProxy The Stage3DProxy to assign the stream to
		 */
		function activateVertexTangentBuffer(index : int, stage3DProxy : Stage3DProxy) : void;

		/**
		 * Retrieves the IndexBuffer3D object that contains triangle indices.
		 * @param context The Context3D for which we request the buffer
		 * @return The VertexBuffer3D object that contains triangle indices.
		 */
		function getIndexBuffer(stage3DProxy : Stage3DProxy) : IndexBuffer3D;

		/**
		 * Retrieves the object's vertices as a Number array.
		 */
		function get vertexData() : Vector.<Number>;

		/**
		 * Retrieves the object's normals as a Number array.
		 */
		function get vertexNormalData() : Vector.<Number>;

		/**
		 * Retrieves the object's tangents as a Number array.
		 */
		function get vertexTangentData() : Vector.<Number>;

		/**
		 * The offset into vertexData where the vertices are placed
		 */
		function get vertexOffset() : int;

		/**
		 * The offset into vertexNormalData where the normals are placed
		 */
		function get vertexNormalOffset() : int;

		/**
		 * The offset into vertexTangentData where the tangents are placed
		 */
		function get vertexTangentOffset() : int;

		/**
		 * Retrieves the object's indices as a uint array.
		 */
		function get indexData() : Vector.<uint>;

		/**
		 * Retrieves the object's uvs as a Number array.
		 */
		function get UVData() : Vector.<Number>;
	}
}
