clear,clc
%% 数据生成
runmode = 'true'; % simple true
fprintf('运行模式: %s\n',runmode);
switch runmode
    case 'simple'
        %% 模型
        mode = 3;
        switch mode
            case 6
                k = [1 3 5 2 -3 6];
                state = '[x^2 x x*y y y^2 1]';
            case 3
                k = [1 3 1];
                state = '[x y 1]';
        end
        nK = length(k);
        % 生成数据
        x = (0:9);
        y = (0:9);
        for ix = 1:length(x)
            for iy = 1:length(y)
                gray(ix,iy) = uint8(abs(model(x(ix),y(iy),k,state)));
            end
        end
    case 'true'
        im = rgb2gray(imread('apriltag-imgs-master\tag36h11\tag36_11_00000.png'));
        [xlen,ylen] = size(im);
        x = uint8(0:xlen-1);
        y = uint8(0:ylen-1);
        gray = im;
end
%%
if ~exist('nK','var')
    nK = 3;
    state = '[x y 1]';
end
A = zeros(nK,nK);
b = zeros(nK,1);
% patterns.x = {[1 length(x)],...
%               };
for ix = length(x)
    for iy = 1:length(y)
        %         % 生成数据
        %         gray(ix,iy) = abs(model(x(ix),y(iy),k,state));
        % 模拟求解
        [tmpA,tmpb] = fitmodel(x(ix),y(iy),gray(ix,iy),state);
        A = A + tmpA;
        b = b + tmpb;
    end
end
gray_high = 3*kron( gray , uint8(ones(10,10)) );

k_res = A\b;
for ix = 1:length(x)
    for iy = 1:length(y)
        gray_res(x(ix)+1,y(iy)+1) = model(x(ix),y(iy),k_res,state);
    end
end

figure;
subplot(221)
imshow( gray_high );
ylabel('原图')
subplot(222)
imshow( uint8(gray_res) );
ylabel('拟合灰度图')
subplot(223)
% 锐化
gray_mean = mean(gray_res(:));
gray_bias = double(gray_res)-double(gray_mean);
shaper_scale = min( abs((255-gray_mean)/max(gray_bias(:))) , abs((gray_mean)/min(gray_bias(:))) ); 
gray_shaper = 0.8*shaper_scale*gray_bias;
gray_shaper = uint8(gray_mean + gray_shaper);
imshow( uint8(gray_shaper) );
ylabel('锐化拟合灰度图')
%%
function gray = model(x,y,k,state)
vec = eval(state);
gray = uint8(dot(double(k),double(vec)));
end

function [A,b] = fitmodel(x,y,gray,state)
Jtrans = eval(state);
J = double(Jtrans');
A = J*J';
b = J*double(gray);
end