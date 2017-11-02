im1 = imread('view2.png'); % left image
im2 = imread('view1.png'); % right image

[h1,w1,c1] = size(im1);
[h2,w2,c2] = size(im2);

figure('Name','Select correspondences','NumberTitle','off');
subplot(1,2,1);
imshow(im1);
subplot(1,2,2);
imshow(im2);

[X2,Y2]=ginput(4);
hold on;
plot(X2,Y2,'go');
[X1,Y1]=ginput(4);
close;

% X1 = [377, 120, 363, 305, 113, 292, 285, 275, 198, 35];
% Y1 = [205, 210, 58, 232, 149, 93, 199, 264, 324, 283];
% X2 = [540, 281, 521, 465, 272, 450, 445, 436, 361, 203];
% Y2 = [177, 191, 18, 209, 131, 68, 176, 240, 302, 263];
A = zeros(8,9);

j=1;
for i=1:4
    A(j,:) = [0 0 0 -X1(i) -Y1(i) -1 Y2(i)*X1(i) Y2(i)*Y1(i) Y2(i)*1];
    A(j+1,:) = [X1(i) Y1(i) 1 0 0 0 -X2(i)*X1(i) -X2(i)*Y1(i) -X2(i)];
    %A(j+2,:) = [-Y2(i)*X1(i) -Y2(i)*Y1(i) -Y2(i)*1 X2(i)*X1(i) X2(i)*Y1(i) X2(i) 0 0 0];
    j=j+2;
end

[U S V] = svd(A,0);
h = V(:,9);

% H*im1 = im2
H = reshape(h,3,3)';

%tl;bl;tr;br
corners = H * [ 1 1 w1 w1 ; 1 h1 1 h1 ; 1 1 1 1 ];

for i=1:length(corners)
    corners(:,i) = corners(:,i)./corners(3,i);
end

[X_coords,Y_coords] = ndgrid(min(corners(1,:)):1:max(corners(1,:)), min(corners(2,:)):1:max(corners(2,:)));
[R C] = size(X_coords);

% Mapping im2 points on im1
inv2 = H \ [X_coords(:)';Y_coords(:)';ones(R*C,1)'];
normMat = repmat(inv2(3,:),3,1);
inv2 = inv2./normMat;

X_inv = reshape(inv2(1,:),R,C)';
Y_inv = reshape(inv2(2,:),R,C)';

canvas = zeros(C,R,3,'uint8');
canvas(:,:,1)=interp2(double(im2(:,:,1)),X_inv,Y_inv);
canvas(:,:,2)=interp2(double(im2(:,:,2)),X_inv,Y_inv);
canvas(:,:,3)=interp2(double(im2(:,:,3)),X_inv,Y_inv);
%imshow(canvas);

x_max = round(max([w1,corners(1,:)]));
x_min = round(min([1,corners(1,:)]));
y_max = round(max([h1,corners(2,:)]));
y_min = round(min([1,corners(2,:)]));

height = y_max - y_min
width = x_max - x_min

% Height of pano = max(height of im1, height of warped im2)
% Width of pano = Width of im1 + |offset along x|
[hc wc cc]=size(canvas);
panorama = zeros(height,width,3,'uint8');

panorama(1:hc,(1:wc)+(width-wc),:)=canvas(1:hc,1:wc,:);
panorama((1:h1)+abs(y_min),1:w1,:) = im1(1:h1,1:w1,:);

figure('Name','Panorama','NumberTitle','off');
imshow(panorama);
imwrite(panorama,'panorama.jpg');
