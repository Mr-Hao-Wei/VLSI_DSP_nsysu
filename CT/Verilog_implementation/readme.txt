Edge_detection_ori.v 為原版電路

Edge_detection.v 為加入technique的電路 

dat_GAU 為Layer1用高斯濾波的data

dat_MED 為Layer1用中值濾波的data

可利用switch選擇要使用的Layer 1 filter，0是中值，1是高斯

二值化門檻固定為56(pattern中的)

使用中值的Layer1和Layer2的結果會全對

使用高斯的則否，因為高斯有WL effect，且軟體生成的pattern是以float point產生，因此轉成fixed point時會在小數做四捨五入等優化，導致軟體的輸出結果與硬體的輸出結果差1
讓TB判別為輸出錯誤。

如果是以高斯濾波器做邊緣偵測，有少數結果會與軟體生成的預期結果不同。這個原因承上一點，由於高斯濾波器的輸出結果和軟體不同，當sobel輸出結果的數值與Threshold接近相近時，可能讓結果與軟體的輸出不同。