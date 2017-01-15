function [imgPixels,vicarProperty] = vicarread(imgName,scale)
%%读取vicar图像
%输入：
%   imgName:vicar图像名，例如:"N1827817331_1.IMG"
%   scale:图像缩放比例，范围为:[0,1]
%
%输出：
%   imgPixels:2D矩阵，类型为uint16或者uint8
%   vicarProperty:结构体，保存了vicar图像Labels中的相关属性

%例子:
% [imgPixels,vicarProperty] = vicarread('N1827817331_1.IMG',0.5);
% imshow(imgPixels)

%参考文献：http://www-mipl.jpl.nasa.gov/external/VICAR_file_fmt.pdf
%作者:李照亮
%时间:2016.11

if(1 == nargin)
    scale = 1;
end
    vicar = getLabels(imgName);
    vicarProperty = vicar;
    image_fd = fopen(imgName,'r');
    %从文件开始部分跳过(vicar.LBLSIZE + vicar.NLB*vicar.RECSIZE)个字节
    fseek(image_fd,vicar.LBLSIZE + vicar.NLB*vicar.RECSIZE,'bof');
    num_records = vicar.N2 * vicar.N3;%每行的字节数
    pixels = [];
    for i = 1:num_records
        fread(image_fd,vicar.NBB);
        if(strcmp('HALF',vicar.FORMAT))%此时，每个像素为二个字节，且为有符号型，用补码表示，且具有大小端的区别
            pixel_data = fread(image_fd,vicar.N1,'int16',0,'b');
            pixel_data = pixel_data*32768*2/(4096.0);          
        elseif(strcmp('BYTE',vicar.FORMAT))%此时，每个像素为一个字节，且为无符号型(0~255)
            pixel_data = fread(image_fd,vicar.N1,'uint8',0,'b');
        end    
        pixels = [pixels;pixel_data'];
    end
    fclose(image_fd);

    if(strcmp('HALF',vicar.FORMAT))
        imgPixels = uint16(pixels);
    else
        imgPixels = uint8(pixels);
    end
    imgPixels = imresize(imgPixels,scale);
end


function metadata_dict = getLabels(imgName)
%     imgName: vicar图像名，例如:"N1827817331_1.IMG"
% 
%     metadata_dict: VICARMetadata的实例.

lblsize = getLBLSIZE(imgName);
metadata_fd = fopen(imgName,'r');
metadata = fread(metadata_fd,[1,lblsize],'*char');
has_lquote = false;
has_lparen = false;
tag_buf = [];
metadata_dict = struct();
for i = 1:length(metadata)
    ch = metadata(i);
    if(strcmp('''',ch))
        if(has_lquote && ~has_lparen)
            [tag,value] = strSplit(tag_buf,'=');
            tag = strtrim(tag);
            metadata_dict = setfield(metadata_dict,tag,value);
            has_lquote = false;
            has_lparen = false;
            tag_buf = [];
        else
            has_lquote = true;
        end
    elseif(strcmp('(',ch))
        has_lparen = true;
        tag_buf = [tag_buf,ch];
    elseif(strcmp(')',ch))     
        tag_buf = [tag_buf,ch];
        [tag,value] = strSplit(tag_buf,'=');   
        tag = strtrim(tag);
        metadata_dict = setfield(metadata_dict,tag,value);
        has_lquote = false;
        has_lparen = false;
        tag_buf = [];
    elseif(strcmp(' ',ch) && ~isempty(tag_buf) && ~(has_lquote || has_lparen))            
        [tag,value] = strSplit(tag_buf,'=');   
        tag = strtrim(tag);
        metadata_dict = setfield(metadata_dict,tag,value);
        has_lquote = false;
        has_lparen = false;
        tag_buf = [];
    elseif(strcmp(' ',ch))
        continue
    else
        tag_buf = [tag_buf,ch];
    end
end
fclose(metadata_fd);
end

function [tag,value] = strSplit(str,ch)
    %根据字符ch将字符串str分成两半

    id = strfind(str,ch);
    tag = str(1:id-1);
    value = str(id+1:end);
    if(~isnan(str2double(value)))
        value = str2double(value);
    end
end

function lblsize = getLBLSIZE(imgName)
%%读取vicar图像
%输入：
%   imgName:vicar图像名，例如:"N1827817331_1.IMG"
%
%输出：
%   lblsize:标量，类型为double

metadata_fd = fopen(imgName,'r');
fread(metadata_fd,8,'*char');
lblsize = [];
while(1)
    ch = fread(metadata_fd,1,'*char');
    if(strcmp(ch,' '))
        break
    else
        lblsize = [lblsize,ch];
    end
end
fclose(metadata_fd);
lblsize = str2double(lblsize);
end
