clear,clc
%% 参数设置
nLevel = 3;
scale = 0.9; % 中心区域替换缩小比例
apriltag_imags_folder = 'apriltag-imgs-master';
% level 1 最大
level(1).tagFamily = 'tagCustom48h12'; % Tag类
level(1).tagNameHead = 'tag48_12_%05d.png'; % tag图片文件名
level(1).tagNumbers = [0]; % tag编号
level(1).nTagPixel = 10; % tag的像素长度
level(1).k = 500; % 像素复制个数
% level 2
level(2).tagFamily = 'tagCustom48h12'; % Tag类
level(2).tagNameHead = 'tag48_12_%05d.png'; % tag图片文件名
% level(2).tagFamily = 'tag36h11'; % Tag类
% level(2).tagNameHead = 'tag36_11_%05d.png'; % tag图片文件名
level(2).tagNumbers = [2]; % tag编号
level(2).nTagPixel = 10; % tag的像素长度
level(2).k = floor(min(500,scale*2*level(1).k/level(1).nTagPixel)); % 像素复制个数
% level 3
level(3).tagFamily = 'tagCustom48h12'; % Tag类
level(3).tagNameHead = 'tag48_12_%05d.png'; % tag图片文件名
level(3).tagNumbers = [4]; % tag编号
level(3).nTagPixel = 10; % tag的像素长度
level(3).k = floor(min(500,scale*2*level(2).k/level(2).nTagPixel)); % 像素复制个数
%%
% 设置结果保存目录
setCenterWhite = true;
saveFloder = 'Level%d_%shighdef';% output保存目录
strFolderName = [];
switch nLevel
    case 1
        strFolderName = [strFolderName level(1).tagFamily,'_'];
    case 2
        strFolderName = [strFolderName level(1).tagFamily,'_',...
            level(1).tagFamily,'_'];
    case 3
        strFolderName = [strFolderName level(1).tagFamily,'_',...
            level(2).tagFamily,'_',...
            level(3).tagFamily,'_'];
end
saveFloder = sprintf(saveFloder,nLevel,strFolderName);
if ~exist(saveFloder,'dir')
    mkdir(saveFloder)
end
% 生成level(1)的高清tag
level(1).pathfolder = [apriltag_imags_folder,'\',...
    level(1).tagFamily, '\'];
level(1).thisTagName = sprintf(level(1).tagNameHead,level(1).tagNumbers);
fprintf('正在处理 %s\n',level(1).thisTagName);
level(1).im_gray = rgb2gray(imread([level(1).pathfolder,level(1).thisTagName]));
[nRow,nCol] = size(level(1).im_gray);
level(1).im_gray_high = kron(level(1).im_gray,ones(level(1).k,'uint8'));

% 生成level(2)的高清tag
if nLevel >= 2
    level(2).pathfolder = [apriltag_imags_folder,'\',...
        level(2).tagFamily, '\'];
    level(2).thisTagName = sprintf(level(2).tagNameHead,level(2).tagNumbers);
    fprintf('正在处理 %s\n',level(2).thisTagName);
    level(2).im_gray = rgb2gray(imread([level(2).pathfolder,level(2).thisTagName]));
    [nRow,nCol] = size(level(2).im_gray);
    level(2).im_gray_high = kron(level(2).im_gray,ones(level(2).k,'uint8'));
    %     imshow(level(2).im_gray_high);
end
% 生成level(3)的高清tag
if nLevel >= 3
    level(3).pathfolder = [apriltag_imags_folder,'\',...
        level(3).tagFamily, '\'];
    level(3).thisTagName = sprintf(level(3).tagNameHead,level(3).tagNumbers);
    fprintf('正在处理 %s\n',level(3).thisTagName);
    level(3).im_gray = rgb2gray(imread([level(3).pathfolder,level(3).thisTagName]));
    [nRow,nCol] = size(level(3).im_gray);
    level(3).im_gray_high = kron(level(3).im_gray,ones(level(3).k,'uint8'));
    %     imshow(level(3).im_gray_high);
end
%% 合成
baseIm = level(1).im_gray_high;
rowSubStart(1) = 0;
colSubStart(1) = 0;
rowWhiteStart(1) = 0;
colWhiteStart(1) = 0;
for i_level = 2:nLevel
    % 中心区域white化
    if setCenterWhite
        rowWhiteStart(i_level-1) = rowSubStart(i_level-1) + 4*level(i_level-1).k;
        colWhiteStart(i_level-1) = colSubStart(i_level-1) + 4*level(i_level-1).k;
        len = 2*level(i_level-1).k;
        baseIm(rowWhiteStart(i_level-1):rowWhiteStart(i_level-1)+len,colWhiteStart(i_level-1):colWhiteStart(i_level-1)+len)...
            = 255*ones(size(baseIm(rowWhiteStart(i_level-1):rowWhiteStart(i_level-1)+len,colWhiteStart(i_level-1):colWhiteStart(i_level-1)+len)));
    end
    % 替换中心区域
    rowSubStart(i_level) = rowSubStart(i_level-1) + 4*level(i_level-1).k + (1-scale)*level(i_level-1).k + 1;
    colSubStart(i_level) = colSubStart(i_level-1) + 4*level(i_level-1).k + (1-scale)*level(i_level-1).k + 1;
    len = level(i_level).k*level(i_level-1).nTagPixel;
    baseIm(rowSubStart(i_level):rowSubStart(i_level)+len-1,colSubStart(i_level):colSubStart(i_level)+len-1)...
        = level(i_level).im_gray_high;
end
% 保存信息
figure;
for i = 1:nLevel
    subplot(2,2,i)
    imshow(level(i).im_gray_high);
    strXlabel = ['level ',num2str(i),': ',level(i).thisTagName];
    strXlabel = strrep(strXlabel,'_','\_');
    xlabel(strXlabel)
end
subplot(224)
imshow(baseIm);
xlabel('层叠tag')
figure;
imshow(baseIm);
xlabel('层叠tag')
%
fprintf('高清tag图片保存在目录：%s\n',saveFloder)
for i = 1:nLevel
    imwrite(level(i).im_gray_high,[saveFloder,'\high_',level(i).thisTagName]);
end
imwrite(baseIm,[saveFloder,'\syn_',strFolderName(1:end-1),'.png']);