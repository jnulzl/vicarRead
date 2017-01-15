# Read-Vicar-image-IMG-format-by-matlab
##读取vicar图像
###输入：
###   imgName:vicar图像名，例如:"N1827817331_1.IMG"
###   scale:图像缩放比例，范围为:[0,1]
###
##输出：
###   imgPixels:2D矩阵，类型为uint16或者uint8
###   vicarProperty:结构体，保存了vicar图像Labels中的相关属性

##例子:
### [imgPixels,vicarProperty] = vicarread('N1827817331_1.IMG',0.5);
### imshow(imgPixels)

##参考文献：http://www-mipl.jpl.nasa.gov/external/VICAR_file_fmt.pdf
##作者:李照亮
##时间:2016.11
