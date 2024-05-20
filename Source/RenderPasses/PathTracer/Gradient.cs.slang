RWTexture2D<float2> gMotionVectors;
RWTexture2D<float4> outputColor;
RWTexture2D<float4> gLastFrameColor;
RWTexture2D<float> gGradient;
RWTexture2D<uint> gisCompGrad;
RWTexture2D<uint> gReFrameCount;

[numthreads(16, 16, 1)]
void computeGrad(uint3 dispatchThreadId : SV_DispatchThreadID)
{

   uint2 pos = dispatchThreadId.xy;



   int isCompGrad = gisCompGrad[pos];

   if(isCompGrad == 1)
   {

   float4 curColor = outputColor[pos];

      // 获取当前像素的运动矢量
   float2 motionVector = gMotionVectors[pos];

    // 计算上一帧中的像素位置
   uint2 prevPos = pos - uint2(motionVector);

       // 获取上一帧中对应像素的颜色
   float4 lastColor = gLastFrameColor[prevPos];

   gLastFrameColor[pos] = curColor;


   //灰度图像
   float graycolor = 1.0/3.0 *(curColor.x + curColor.y + curColor.z);

   float lastgraycolor = 1.0/3.0 * (lastColor.x + lastColor.y + lastColor.z);

   float diffgray = abs(graycolor - lastgraycolor);



   float gradient = diffgray;


   
   

   gGradient[pos] = gradient;


   gReFrameCount[pos] = 1;

   }
   else
   {
   int ReFrameCount = gReFrameCount[pos];

   gReFrameCount[pos] = ReFrameCount + 1;
   }
}
