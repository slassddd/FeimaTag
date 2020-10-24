clear,clc
%% 参数设置
nLevel = 1;
% level 1 最大
idx_level = 1;
level(idx_level).tagFamily = 'tag36h11'; % Tag类
level(idx_level).tagNameHead = 'tag36_11_%05d.png'; % tag图片文件名
% level(idx_level).tagFamily = 'tagCustom48h12'; % Tag类
% level(idx_level).tagNameHead = 'tag48_12_%05d.png'; % tag图片文件名
level(idx_level).tagNumbers = [0,112,412]; % tag编号
level(idx_level).k = 50; % 像素复制个数
level(idx_level).nTagPixel = 10; % tag的像素长度
%%
% 设置结果保存目录
saveFloder = ['Level%d_%shighdef'];% output保存目录
strFolderName = [];
for i = 1:nLevel
    strFolderName = [strFolderName level(i).tagFamily,'_'];
end
saveFloder = sprintf(saveFloder,nLevel,strFolderName);
if ~exist(saveFloder,'dir')
    mkdir(saveFloder)
end
% 生成level1的高清tag
i_level = 1;
level(i_level).pathfolder = ['apriltag-imgs-master','\',...
    level(i_level).tagFamily, '\'];
level(i_level).nTags = length(level(i_level).tagNumbers); %
for i_tag = 1:level(i_level).nTags
    thisTagName = sprintf(level(i_level).tagNameHead,level(i_level).tagNumbers(i_tag));
    fprintf('正在处理 %s (%d/%d)\n',thisTagName, i_tag, level(i_level).nTags);
    level(i_level).im_gray{i_tag} = rgb2gray(imread([level(i_level).pathfolder,thisTagName]));
    [nRow,nCol] = size(level(i_level).im_gray{i_tag});
    level(i_level).im_gray_high{i_tag} = kron(level(i_level).im_gray{i_tag},ones(level(i_level).k,'uint8'));
    imshow(level(i_level).im_gray_high{i_tag});
    imwrite(level(i_level).im_gray_high{i_tag},[saveFloder,'\high_',thisTagName]);
end
% 
fprintf('高清tag图片保存在目录：%s\n',saveFloder)