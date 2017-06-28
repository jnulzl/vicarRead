# **利用MATLAB读取Vicar图像(Reading Vicar image using MATLAB)**
## **1、输入**：
###   imgName:vicar图像名，例如:"N1827817331_1.IMG"
###   scale:图像缩放比例，范围为:[0,1]

## **2、输出**：
###   imgPixels:2D矩阵，类型为uint16或者uint8
###   vicarProperty:结构体，保存了vicar图像Labels中的相关属性

## **3、例子**:
### [imgPixels,vicarProperty] = vicarread('N1827817331_1.IMG',0.5);
### imshow(imgPixels)
![测试截图](https://github.com/jnulzl/vicarRead/blob/master/testScreenshots.png)
## **参考文献**：[The VICAR file format](http://www-mipl.jpl.nasa.gov/external/VICAR_file_fmt.pdf)
## **作者**:李照亮
## **时间**:2016.11
