
RWTexture2D<float4> outputColor;
RWTexture2D<float4> gLastFrameSum;
RWTexture2D<float> gDiffTexture;
Texture2D<uint> gSampleStepTexture;

uint gmFrameCount;

[numthreads(16, 16, 1)]
void computePool(uint3 dispatchThreadId : SV_DispatchThreadID)
{
   uint2 pos = dispatchThreadId.xy;

   float4 curColor = outputColor[pos];

   float4 lastColor = gLastFrameSum[pos];

   uint SampleStep = gSampleStepTexture[pos];

   if (SampleStep == 0)
   {
       gDiffTexture[pos] = 0.0;
   }
   else
   {

   //累积
   float4 output;
   float curWeight = 1.0 / (gmFrameCount + 1);
   output = lerp(lastColor, curColor, curWeight);


   //灰度图像
   float graycolor = 1.0/3.0 *(255 * output.x + 255 * output.y + 255 * output.z);

   float lastgraycolor = 1.0/3.0 * (255 * lastColor.x + 255 * lastColor.y + 255 * lastColor.z);

   float diffgray = abs(graycolor - lastgraycolor);

   gDiffTexture[pos] = diffgray;

   }
}
