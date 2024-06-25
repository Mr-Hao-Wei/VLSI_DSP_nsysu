超大型積體電路數位訊號處理 (VLSI-DSP)

授課教授: 施信毓 教授

修課時間: 大四下

Team Project內容:

    1.Teaching Edge (TE):

      Requirements:設計兩個不同的主題來將被抽選到的課程單元以有創意的方式進行翻轉教學，其內容要包含
      
                    1.問題闡述
      
                    2.解題過程
      
                    3.最終解答
                    
      Oral presentation time:15分鐘

      Project實作內容: 
      
                     抽選到的課程單元:Unfolding

                     Topic 1:以餐廳出餐流程來介紹並講解Unfolding的特性及優缺點

                     Topic 2:將累加乘法器進行Unfolding實作

    2.Filter Circle (FC):

      Requirements:實作任一種類的band-stop filter並進行finite-wordlength分析

      Oral presentation time:15分鐘

      Project實作內容:以ecg和pli訊號為例，分析並設計一band-stop filter來濾除ecg訊號中的pli雜訊
                
                     Band-stop filter type: IIR Chebyshev II

                     硬體架構: Sixth-Order IIR band-stop filter with IIR Cascaded Second-Order Sections Direct Form II

    3.Engine Show (ES):                  

      Requirements:設計一9位元複數輸入的11-point FFT並加入2種課程內學到的技術，最後完成功能驗證和新舊電路之分析

      Oral presentation time:15分鐘

      Project實作內容: 
      
                     11-point FFT演算法:以雷德演算法為基礎，加入更多演算法簡化計算

                     參考文獻:I. W. Selesnick and C. S. Burrus, “Automatic generation of prime length FFT programs,” IEEE Transactions on Signal Processing, vol. 44, no. 1, pp. 14-24, Jan. 1996.

                     加入技術: Pipeline + Parallel

    4.Circuit Talk (CT):

      Requirements:實作任一種類的DSP circuit engine，需加入4種以上課程內學到的技術並對其進行效能比較和分析

      Oral presentation time:15分鐘

      Project實作內容:

                     DSP circuit engine:圖像邊緣檢測電路
    
                     功能:將灰階圖片先進行模糊濾波(Gaussian filter or Median filter)，接著再做邊緣偵測(Sobel filter)，最後二值化輸出

                     使用技術:

                             1. Systolic array: Median filter

                             2. Pipeline: Gaussian filter + Median filter

                             3. Folding: Sobel filter

                             4. Retiming: Sobel filter

                             5. Scheduling (Life Time Analysis): 僅作理論分析，並未實現
                    

