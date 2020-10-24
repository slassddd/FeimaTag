tagFamily = 'tagCustom48h12'; % Tag类
saveFloder = [tagFamily,'_highdef']; % output保存目录
if ~exist(saveFloder,'dir')
    mkdir(saveFloder)
end
pathfolder = ['apriltag-imgs-master','\',...
    tagFamily, '\'];
tagNameHead = 'tag48_12_%05d.png'; % tag图片文件名
tagNumbers = [0,1,2,3,4,5,100,200]; % tag编号
nTags = length(tagNumbers); %
for i = 1:nTags
    thisTagName = sprintf(tagNameHead,tagNumbers(i));
    fprintf('正在处理 %s (%d/%d)\n',thisTagName, i, nTags);
    im_gray = rgb2gray(imread([pathfolder,thisTagName]));
    [nRow,nCol] = size(im_gray);
    k = 50; % 像素复制个数
    im_gray_high = kron(im_gray,ones(k,'uint8'));
    imshow(im_gray_high);
    imwrite(im_gray_high,[saveFloder,'\high_',thisTagName]);
end
fprintf('高清tag图片保存在目录：%s\n',saveFloder)