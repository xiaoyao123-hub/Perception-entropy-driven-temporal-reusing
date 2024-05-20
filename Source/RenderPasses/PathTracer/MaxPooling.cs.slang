Texture2D<uint> gJNDTexture;
RWTexture2D<float> gDiffTexture;
RWTexture2D<float> gPDFTexture1;
RWTexture2D<float> gPDFTexture2;
RWTexture2D<float> gPDFTexture3;
RWTexture2D<float> gPDFTexture4;
RWTexture2D<float> gPDFTexture5;
RWTexture2D<float> gPDFTexture6;
RWTexture2D<float> gPDFTexture7;
RWTexture2D<float> gPDFTexture8;

[numthreads(16, 16, 1)]
void computeMaxPool(uint3 dispatchThreadId : SV_DispatchThreadID)
{
   uint2 pos = dispatchThreadId.xy;

   float JND = gJNDTexture[pos];

   float pdf1 = gPDFTexture1[pos];
   float pdf2 = gPDFTexture2[pos];
   float pdf3 = gPDFTexture3[pos];
   float pdf4 = gPDFTexture4[pos];
   float pdf5 = gPDFTexture5[pos];
   float pdf6 = gPDFTexture6[pos];
   float pdf7 = gPDFTexture7[pos];
   float pdf8 = gPDFTexture8[pos];

   float shang1 = - pdf1 * log2(pdf1);
   float shang2 = - pdf2 * log2(pdf2);
   float shang3 = - pdf3 * log2(pdf3);
   float shang4 = - pdf4 * log2(pdf4);
   float shang5 = - pdf1 * log2(pdf5);
   float shang6 = - pdf2 * log2(pdf6);
   float shang7 = - pdf3 * log2(pdf7);
   float shang8 = - pdf4 * log2(pdf8);

   float shang = shang1 + shang2 + shang3 + shang4 + shang5 + shang6 + shang7 + shang8;


   //float center = gDiffTexture[pos];
   //float top = gDiffTexture[pos + uint2(0, -1)];
   //float bottom = gDiffTexture[pos + uint2(0, 1)];
   //float left = gDiffTexture[pos + uint2(-1, 0)];
   //float right = gDiffTexture[pos + uint2(1, 0)];
   //float topleft = gDiffTexture[pos + uint2(-1, -1)];
   //float topright = gDiffTexture[pos + uint2(1, -1)];
   //float bottomleft = gDiffTexture[pos + uint2(-1, 1)];
   //float bottomright = gDiffTexture[pos + uint2(1, 1)];

   //float maxVal = max(center, max(top, max(bottom, max(left, max(right, max(topleft, max(topright, max(bottomleft, bottomright))))))));


   if(shang <= 0 || isnan(shang))
   {
      shang = 1;
   }

   float entropy_item = 1.0 / shang;

   //float yuzhi = 3.0 + 1.0 * pow(JND,entropy_item);
   float yuzhi =  4.373 * pow(JND,entropy_item);

   if(yuzhi < 0 || yuzhi > 200)
   {
       yuzhi = 100;
   }

   gDiffTexture[pos] = yuzhi;




}
