I = (imread('high_tag36_11_00071.png'));
tagFamily = ["tag36h11"];
focalLength = [2000,2000];
principalPoint = [1080,963];
imageSize = size(I);
intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
% intrinsics = [2000,0,1080;0 2000 963;0 0 1];
tagSize = 0.1;
[id,loc,pose] = readAprilTag(I,tagFamily,intrinsics,tagSize);

for idx = 1:length(id)
        % Display the ID and tag family
        disp("Detected Tag ID, Family: " + id(idx));
        % Insert markers to indicate the locations
        markerRadius = 8;
        numCorners = size(loc,1);
        markerPosition = [loc(:,:,idx),repmat(markerRadius,numCorners,1)];
        I = insertShape(I,"FilledCircle",markerPosition,"Color","red","Opacity",1);
end
imshow(I)
