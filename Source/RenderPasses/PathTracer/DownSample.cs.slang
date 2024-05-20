RWTexture2D<float> gDownSample; // 输出的下采样后的纹理
Texture2D<float> gGradient; // 输入的原始纹理

[numthreads(16, 16, 1)]
void computeDown(uint3 dispatchThreadId : SV_DispatchThreadID)
{
    uint2 pos = dispatchThreadId.xy;

    uint2 downsampledPos = pos;


    // 计算8x8像素块中的最大值
    float maxVal = 0.0f;
    for (int i = 0; i < 8; ++i)
    {
        for (int j = 0; j < 8; ++j)
        {
            float val = 0.0f;
            uint2 GradPos = uint2(downsampledPos.x + i,downsampledPos.y + j);

            if (GradPos.x < 1920 && GradPos.y < 1061) // 在原始纹理范围内才获取像素值
            {
                val = gGradient[GradPos];
            }

            maxVal = max(maxVal, val);
        }
    }


    // 将最大值写入下采样后的纹理中
    gDownSample[pos] = maxVal;
}
