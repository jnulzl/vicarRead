function imgPixels = demo(imgName,vicar)
%%读取vicar图像
%输入：
%   imgName:vicar图像名，例如:"N1827817331_1.IMG"
%   scale:图像缩放比例，
%
%输出：
%   imgPixels:2D矩阵，类型为uint16或者uint8

% if(2 == nargin)
%     scale = 1;
% end
%     vicar = process_metadata(imgName);
    image_fd = fopen(imgName,'r');
    %从文件开始部分跳过(vicar.LBLSIZE + vicar.NLB*vicar.RECSIZE)个字节
    fread(image_fd,vicar.LBLSIZE + vicar.NLB*vicar.RECSIZE);
%     fseek(image_fd,vicar.LBLSIZE + vicar.NLB*vicar.RECSIZE,'bof');
    num_records = vicar.N2 * vicar.N3;%每行的字节数
    pixels = [];
    for i = 1:num_records
        fread(image_fd,vicar.NBB);
        if(strcmp('HALF',vicar.FORMAT))%此时，每个像素为二个字节，且为有符号型，用补码表示，且具有大小端的区别
            pixel_data = fread(image_fd,vicar.N1,'int16',0,'b');
    %         if(strcmp('HIGH',vicar.INTFMT))
    %             pixel_data = fread(image_fd,vicar.N1,'int16',0,'b');
    %         else
    %             pixel_data = fread(image_fd,vicar.N1,'int16',0,'l');
    %         end
            pixel_data = pixel_data*32768*2/(4096.0);          
        elseif(strcmp('BYTE',vicar.FORMAT))%此时，每个像素为一个字节，且为无符号型(0~255)
    %         if(strcmp('HIGH',vicar.INTFMT))
    %             pixel_data = fread(image_fd,vicar.N1,'uint8',0,'b');
    %         else
    %             pixel_data = fread(image_fd,vicar.N1,'uint8',0,'l');
    %         end
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
%     imgPixels = imresize(imgPixels,scale);
end
