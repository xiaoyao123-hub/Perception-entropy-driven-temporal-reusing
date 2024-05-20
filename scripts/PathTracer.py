from falcor import *

def render_graph_PathTracer():
    # 创建一个名为 "PathTracer" 的渲染图
    g = RenderGraph("PathTracer")

    # 创建 PathTracer Pass，设置每像素采样次数为 1
    PathTracer = createPass("PathTracer", {'samplesPerPixel': 1})
    g.addPass(PathTracer, "PathTracer")

    # 创建 VBufferRT Pass，设置采样模式为 'Stratified'，采样次数为 16，启用 Alpha 测试
    VBufferRT = createPass("VBufferRT", {'samplePattern': 'Stratified', 'sampleCount': 16, 'useAlphaTest': True})
    g.addPass(VBufferRT, "VBufferRT")

    # 创建 AccumulatePass，设置为禁用状态，精度模式为 'Single'
    AccumulatePass = createPass("AccumulatePass", {'enabled': False, 'precisionMode': 'Single'})
    g.addPass(AccumulatePass, "AccumulatePass")

    # 创建 OptixDenoiser Pass
    OptixDenoiser = createPass("OptixDenoiser", {'hdr': False})
    g.addPass(OptixDenoiser, "OptixDenoiser")

    # 创建 ToneMapper Pass，禁用自动曝光，曝光补偿为 0.0
    ToneMapper = createPass("ToneMapper", {'autoExposure': False, 'exposureCompensation': 0.0})
    g.addPass(ToneMapper, "ToneMapper")

    # 添加渲染图的边，将 VBufferRT 的 vbuffer 输出连接到 PathTracer 的 vbuffer 输入
    g.addEdge("VBufferRT.vbuffer", "PathTracer.vbuffer")

    # 将 VBufferRT 的 viewW 输出连接到 PathTracer 的 viewW 输入
    g.addEdge("VBufferRT.viewW", "PathTracer.viewW")

    # 将 VBufferRT 的 mvec 输出连接到 PathTracer 的 mvec 输入
    g.addEdge("VBufferRT.mvec", "PathTracer.mvec")

    # 将 PathTracer 的 color 输出连接到 AccumulatePass 的 input 输入
    g.addEdge("PathTracer.color", "AccumulatePass.input")

    # 将 AccumulatePass 的 output 输出连接到 OptixDenoiser 的 color 输入
    g.addEdge("AccumulatePass.output", "OptixDenoiser.color")

    # 将 OptixDenoiser 的 output 输出连接到 ToneMapper 的 src 输入
    g.addEdge("OptixDenoiser.output", "ToneMapper.src")

    # 标记 ToneMapper 的 dst 输出为渲染图的最终输出
    g.markOutput("ToneMapper.dst")

    return g

# 创建并返回 PathTracer 渲染图
PathTracer = render_graph_PathTracer()

# 尝试将渲染图添加到渲染图管理器中
try: 
    m.addGraph(PathTracer)
except NameError: 
    pass
