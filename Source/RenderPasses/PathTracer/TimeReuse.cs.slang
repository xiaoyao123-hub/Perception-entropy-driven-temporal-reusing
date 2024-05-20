
RWTexture2D<float2> gMotionVectors;
RWTexture2D<float4> outputColor;
RWTexture2D<float4> gLastFrameColor;
RWTexture2D<float> gConvSample;
RWTexture2D<uint> gSampleStepTexture;
RWTexture2D<uint> gisCompGrad;
RWTexture2D<uint> gReFrameCount;
RWTexture2D<uint> gDiffTexture;
RWTexture2D<uint> gdTexture;

[numthreads(16, 16, 1)]
void computeReuse(uint3 dispatchThreadId : SV_DispatchThreadID)
{
   uint2 pos = dispatchThreadId.xy;



    // 获取当前像素的运动矢量
   float2 motionVector = gMotionVectors[pos];

    // 计算上一帧中的像素位置
   uint2 prevPos = pos - uint2(motionVector);

    // 获取上一帧中对应像素的颜色
   float4 lastFrameColor = gLastFrameColor[prevPos];

   

   int d = int(gDiffTexture[pos] / gConvSample[pos]);
  

   if(d > 20)
   {
      d = 20;
   }


   gdTexture[pos] = d;

   int ReFrameCount = gReFrameCount[pos];
   

   if(ReFrameCount < d)
   {

       gSampleStepTexture[pos] = 0;

       gisCompGrad[pos] = 0;


   }
   else
   {

      gSampleStepTexture[pos] = 8;

      gisCompGrad[pos] = 1; 

   }

  // 将当前帧的像素颜色写入输出纹理
  outputColor[pos] = lastFrameColor;

}
