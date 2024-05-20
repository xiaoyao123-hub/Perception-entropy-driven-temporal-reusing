RWTexture2D<float> gConvSample; // 输出的卷积后的纹理
Texture2D<float> gDownSample; // 输入的下采样后的纹理

[numthreads(16, 16, 1)]
void computeConv(uint3 dispatchThreadId : SV_DispatchThreadID)
{
    uint2 pos = dispatchThreadId.xy;

    // 计算卷积后的纹理位置
    uint2 convolvedPos = pos;

    // 计算卷积核的中心位置
    int centerX = 4;
    int centerY = 4;

    // 执行9x9卷积操作
    float result = 0.0f;
    for (int i = -centerX; i <= centerX; ++i)
    {
        for (int j = -centerY; j <= centerY; ++j)
        {
            int x = convolvedPos.x + i;
            int y = convolvedPos.y + j;

            uint2 DownPos = uint2(x, y);

            // 边界处理，超出边界的像素使用0填充
            if (x < 0 || x >= 1920 || y < 0 || y >= 1061)
                result += 0.0f;
            else
                result += gDownSample[DownPos];
        }
    }

    // 将卷积结果写入输出的纹理中
    result /= (centerX * 2 + 1) * (centerY * 2 + 1);
    gConvSample[convolvedPos] = result;
}
