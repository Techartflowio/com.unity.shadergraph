Shader "COC/ParticleUI_SG"
{
    Properties
    {
        [HDR]_Color("Tint", Color) = (1, 1, 1, 0)
        _MainTex("MainTexture", 2D) = "white" {}

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

    
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Fog { Mode Off }
        Blend One One

        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
            #pragma exclude_renderers d3d11_9x
            #pragma vertex vert
            #pragma fragment frag
            
    

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP
        
            // Defines
            
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEUNLIT
            #define ALPHA_CLIP_THRESHOLD 1
            
        
            
            
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float4 texCoord0;
                float4 color;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
            
            };

            struct SurfaceDescriptionInputs
            {
                float4 uv0;
            };

            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
            };

            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0 : INTERP0;
                float4 color : INTERP1;
                float3 positionWS : INTERP2;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
            };
            
            PackedVaryings PackVaryings (Varyings input)
            {
                PackedVaryings output;
                ZERO_INITIALIZE(PackedVaryings, output);
                output.positionCS = input.positionCS;
                output.texCoord0.xyzw = input.texCoord0;
                output.color.xyzw = input.color;
                output.positionWS.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                return output;
            }
            
            Varyings UnpackVaryings (PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.texCoord0.xyzw;
                output.color = input.color.xyzw;
                output.positionWS = input.positionWS.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
        
            // --------------------------------------------------
            // Graph
            
            // Graph Properties
            
            float4 _Color;
            float4 _MainTex_TexelSize;
            float4 _MainTex_ST;
            half4 _TextureSampleAdd;
            half4 _ClipRect;
                
        
            // Object and Global properties
            SAMPLER(SamplerState_Linear_Repeat);
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            
            // Graph Functions
            
            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
        
            // Graph Vertex
            struct VertexDescription
            {
                float3 Position;
                float3 Normal;
                float3 Tangent;
            };
        
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                description.Position = IN.ObjectSpacePosition;
                description.Normal = IN.ObjectSpaceNormal;
                description.Tangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Custom interpolators, pre surface
            #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
            // Graph Pixel
            struct SurfaceDescription
            {
                float3 BaseColor;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 Color = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
                UnityTexture2D _Property_6d6cf54a251245b68399415ba29f6ef5_Out_0_Texture2D = UnityBuildTexture2DStruct(_MainTex);
                float4 BaseMap = SAMPLE_TEXTURE2D(_Property_6d6cf54a251245b68399415ba29f6ef5_Out_0_Texture2D.tex, _Property_6d6cf54a251245b68399415ba29f6ef5_Out_0_Texture2D.samplerstate, _Property_6d6cf54a251245b68399415ba29f6ef5_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
                float4 Res;
                Unity_Multiply_float4_float4(Color, BaseMap, Res);
                surface.BaseColor = (Res.xyz);
                surface.BaseColor *= ( BaseMap.a * Color.a );
                // GUI 알파 처리는 실제로 사용되지 않음. Additive 알파 처리 되는 것이며 Fading 에 더 가까움. 즉 surface.Alpha 에 값을 넣어도 실제로 사용되지 않음.
                // 위 surface.BaseColor *= ( BaseMap.a * Color.a ); 과 같은 방식으로 실제 스프라이트의 rgb 값에 오파시티 벨류값을 곱해서 검정색에 가깝게 만드는 형식으로 Alpha Fade 하는 것임.
                surface.Alpha =1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
            
            // --------------------------------------------------
            // Build Graph Inputs
            
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =                          input.normalOS;
                output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                output.ObjectSpacePosition =                        input.positionOS;
            
                return output;
            }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                    return output;
            }  
        
            // --------------------------------------------------
            // Main
            
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
            
         ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}