#import "Renderer.h"
#import "shaders/ShaderTypes.h"
#import "util/log_util.h"

@implementation Renderer {
    // renderer global ivars
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLBuffer> _vertices;
    id<MTLTexture> _depthTarget;

    // Render pass descriptor which creates a render command encoder to draw to the drawable
    // textures
    MTLRenderPassDescriptor* _drawableRenderDescriptor;

    vector_uint2 _viewportSize;

    NSUInteger _frameNum;
}

- (nonnull instancetype)initWithMetalDevice:(nonnull id<MTLDevice>)device
                        drawablePixelFormat:(MTLPixelFormat)drawabklePixelFormat {
    self = [super init];
    if (self) {
        _frameNum = 0;

        _device = device;

        _commandQueue = [_device newCommandQueue];

        _drawableRenderDescriptor = [MTLRenderPassDescriptor new];
        _drawableRenderDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        _drawableRenderDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        _drawableRenderDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 1, 1, 1);

        {
            NSString* libraryFile = [[NSBundle mainBundle] pathForResource:@"shaders/shaders"
                                                                    ofType:@"metallib"];
            id<MTLLibrary> shaderLib = [_device newLibraryWithFile:libraryFile error:nil];
            if (!shaderLib) {
                custom_log(OS_LOG_TYPE_ERROR, @"Renderer",
                           @"Couldnt create a default shader library");
                // assert here because if the shader libary isn't loading, nothing good will happen
                return nil;
            }

            id<MTLFunction> vertexProgram = [shaderLib newFunctionWithName:@"vertexShader"];
            if (!vertexProgram) {
                custom_log(OS_LOG_TYPE_ERROR, @"Renderer",
                           @"Couldn't load vertex function from default library");
                return nil;
            }

            id<MTLFunction> fragmentProgram = [shaderLib newFunctionWithName:@"fragmentShader"];
            if (!fragmentProgram) {
                custom_log(OS_LOG_TYPE_ERROR, @"Renderer",
                           @"Couldn't load fragment function from default library");
                return nil;
            }

            // Set up a simple MTLBuffer with the vertices, including position and texture
            // coordinates
            static const Vertex quadVertices[] = {
                // Pixel positions, Color coordinates
                {{250, -250}, {1.f, 0.f, 0.f}},   //
                {{-250, -250}, {0.f, 1.f, 0.f}},  //
                {{-250, 250}, {0.f, 0.f, 1.f}},   //
                {{250, -250}, {1.f, 0.f, 0.f}},   //
                {{-250, 250}, {0.f, 0.f, 1.f}},   //
                {{250, 250}, {1.f, 0.f, 1.f}},    //
            };

            // Create a vertex buffer, and initialize it with the vertex data.
            _vertices = [_device newBufferWithBytes:quadVertices
                                             length:sizeof(quadVertices)
                                            options:MTLResourceStorageModeShared];

            _vertices.label = @"Quad";

            // Create a pipeline state descriptor to create a compiled pipeline state object
            MTLRenderPipelineDescriptor* pipelineDescriptor =
                [[MTLRenderPipelineDescriptor alloc] init];

            pipelineDescriptor.label = @"MyPipeline";
            pipelineDescriptor.vertexFunction = vertexProgram;
            pipelineDescriptor.fragmentFunction = fragmentProgram;
            pipelineDescriptor.colorAttachments[0].pixelFormat = drawabklePixelFormat;

            NSError* error;
            _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor
                                                                     error:&error];
            if (!_pipelineState) {
                custom_log(OS_LOG_TYPE_ERROR, @"Renderer", @"Failed aquiring pipeline state: %@",
                           error);
                return nil;
            }
        }
    }
    return self;
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer*)metalLayer {
    _frameNum++;

    // Create a new command buffer for each render pass to the current drawable.
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];

    id<CAMetalDrawable> currentDrawable = [metalLayer nextDrawable];

    // If the current drawable is nil, skip rendering this frame
    if (!currentDrawable) {
        return;
    }

    _drawableRenderDescriptor.colorAttachments[0].texture = currentDrawable.texture;

    id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:_drawableRenderDescriptor];

    [renderEncoder setRenderPipelineState:_pipelineState];

    [renderEncoder setVertexBuffer:_vertices offset:0 atIndex:VertexInputIndexVertices];

    {
        Uniforms uniforms;
        uniforms.viewportSize = _viewportSize;

        [renderEncoder setVertexBytes:&uniforms
                               length:sizeof(uniforms)
                              atIndex:VertexInputIndexUniforms];
    }

    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];

    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:currentDrawable];

    [commandBuffer commit];

    [commandBuffer waitUntilScheduled];
}

- (void)drawableResize:(CGSize)drawableSize {
    _viewportSize.x = drawableSize.width;
    _viewportSize.y = drawableSize.height;
}

@end
