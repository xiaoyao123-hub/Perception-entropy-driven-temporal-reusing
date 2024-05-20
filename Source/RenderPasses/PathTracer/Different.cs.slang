
RWTexture2D<float4> outputColor;
RWTexture2D<float4> gLastFrameColor;
RWTexture2D<float4> gLastFrameSum;
RWTexture2D<float> gDiffTexture;
Texture2D<uint> gJNDTexture;
RWTexture2D<uint> gSampleCountTexture;
RWTexture2D<uint> gSampleStepTexture;
uint gmFrameCount;

[numthreads(16, 16, 1)]
void computeDiff(uint3 dispatchThreadId : SV_DispatchThreadID)
{
   uint2 pos = dispatchThreadId.xy;

   float4 curColor = outputColor[pos];

   float4 lastColor = gLastFrameSum[pos];

   uint SampleStep = gSampleStepTexture[pos];

   if (SampleStep == 0)
   {
      
       outputColor[pos] = lastColor;
   }
   else
   {

   float gJNDColorValue = gJNDTexture[pos];


   //累积
   float4 output;
   float curWeight = 1.0 / (gmFrameCount + 1);
   output = lerp(lastColor, curColor, curWeight);
   gLastFrameSum[pos] = output;

   float graycolor = 1.0/3.0 *(output.x + output.y + output.z);

   float lastgraycolor = 1.0/3.0 * (lastColor.x + lastColor.y + lastColor.z);

   float diffgray = abs(graycolor - lastgraycolor);

   float maxVal = gDiffTexture[pos];


   uint step;


   if(maxVal >= gJNDColorValue)
   {
       //计算步长
       uint stepmin = 8;
       uint stepmax = 24;

       step = (1 + (diffgray/graycolor) * (diffgray/graycolor) ) * (1 + (1/gJNDColorValue) * (1/gJNDColorValue));
       step = step * stepmin;

       if (step < stepmin)
       {
          step = stepmin;
       }
      else if (step > stepmax)
      {
          step = stepmax;
       }

   }
   else
   {
        step = 0;
   }


   gSampleStepTexture[pos] = step;

   uint samplecout = gSampleCountTexture[pos];

   samplecout = samplecout + step;

   gSampleCountTexture[pos] = samplecout;


   outputColor[pos] = output;


   }
}
