using UnityEngine;
using UnityEditor.ShaderGraph.Internal;

namespace UnityEditor.ShaderGraph
{
    internal static class BlockFieldsTafio
    {
        [GenerateBlocks]
        public struct VertexDescription
        {
            public static string name = "VertexDescription";
            public static BlockFieldDescriptor Position = new BlockFieldDescriptor(VertexDescription.name, "Position", "VERTEXDESCRIPTION_POSITION",
                new PositionControl(CoordinateSpace.Object), ShaderStage.Vertex);
            public static BlockFieldDescriptor Normal = new BlockFieldDescriptor(VertexDescription.name, "Normal", "VERTEXDESCRIPTION_NORMAL",
                new NormalControl(CoordinateSpace.Object), ShaderStage.Vertex);
            public static BlockFieldDescriptor Tangent = new BlockFieldDescriptor(VertexDescription.name, "Tangent", "VERTEXDESCRIPTION_TANGENT",
                new TangentControl(CoordinateSpace.Object), ShaderStage.Vertex);
        }

        [GenerateBlocks]
        public struct StencilDescription
        {
            public static string name = "StencilDescription";
            
            public static BlockFieldDescriptor StencilComp = new BlockFieldDescriptor(StencilDescription.name, "StencilComp", "Stencil Comparison", "SURFACEDESCRIPTION_STENCILCOMPARISON",
                new FloatControl(8.0f), ShaderStage.Fragment);
            public static BlockFieldDescriptor Stencil = new BlockFieldDescriptor(StencilDescription.name, "Stencil", "SURFACEDESCRIPTION_STENCIL",
                new FloatControl(0.0f), ShaderStage.Fragment);
            public static BlockFieldDescriptor StencilOp = new BlockFieldDescriptor(StencilDescription.name, "StencilOp", "Stencil Operation", "SURFACEDESCRIPTION_STENCILEOPERATION",
                new FloatControl(0.0f), ShaderStage.Fragment);
            public static BlockFieldDescriptor StencilWriteMask = new BlockFieldDescriptor(StencilDescription.name, "StencilWriteMask", "Stencil Write Mask", "SURFACEDESCRIPTION_STENCILWRITEMASK",
                new FloatControl(255.0f), ShaderStage.Fragment);
            public static BlockFieldDescriptor StencilReadMask = new BlockFieldDescriptor(StencilDescription.name, "StencilReadMask", "Stencil Read Mask", "SURFACEDESCRIPTION_STENCILREADMASK",
                new FloatControl(255.0f), ShaderStage.Fragment);
            public static BlockFieldDescriptor ColorMask = new BlockFieldDescriptor(StencilDescription.name, "Colormask", "Color Mask", "SURFACEDESCRIPTION_COLORMASK",
                new FloatControl(15.0f), ShaderStage.Fragment);
            
        }
        

        [GenerateBlocks]
        public struct SurfaceDescriptionLegacy
        {
            public static string name = "SurfaceDescription";
            public static BlockFieldDescriptor SpriteColor = new BlockFieldDescriptor(StencilDescription.name, "SpriteColor", "SURFACEDESCRIPTION_SPRITECOLOR",
                new ColorRGBAControl(UnityEngine.Color.white), ShaderStage.Fragment, isHidden: true);
        }
    }
}
