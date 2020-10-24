%% 参数设置
nLevel = 2;
% level 1 最大
idx_level = 1;
level(idx_level).tagFamily = 'tagCustom48h12'; % Tag类
level(idx_level).tagNameHead = 'tag48_12_%05d.png'; % tag图片文件名
level(idx_level).tagNumbers = [0,1,2,3,4,5,100,200]; % tag编号
level(idx_level).k = 50; % 像素复制个数
% level 2 
idx_level = 2;
level(idx_level).tagFamily = 'tag36h11'; % Tag类
level(idx_level).tagNameHead = 'tag36_11_%05d.png'; % tag图片文件名
level(idx_level).tagNumbers = [2]; % tag编号
level(idx_level).k = 50; % 像素复制个数
%%
saveFloder = [level(1).tagFamily,'_highdef']; % output保存目录
if ~exist(saveFloder,'dir')
    mkdir(saveFloder)
end
pathfolder = ['apriltag-imgs-master','\',...
    level(1).tagFamily, '\'];
nTags = length(level(1).tagNumbers); %
for i = 1:nTags
    thisTagName = sprintf(level(1).tagNameHead,level(1).tagNumbers(i));
    fprintf('正在处理 %s (%d/%d)\n',thisTagName, i, nTags);
    im_gray = rgb2gray(imread([pathfolder,thisTagName]));
    [nRow,nCol] = size(im_gray);    
    im_gray_high = kron(im_gray,ones(k,'uint8'));
    imshow(im_gray_high);
    imwrite(im_gray_high,[saveFloder,'\high_',thisTagName]);
end
fprintf('高清tag图片保存在目录：%s\n',saveFloder)