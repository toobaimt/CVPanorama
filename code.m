im1 = imread('view2.png'); % left image
im2 = imread('view1.png'); % right image

[h1,w1,c1] = size(im1);
[h2,w2,c2] = size(im2);

% subplot(1,2,1);
% imshow(im1);
% subplot(1,2,2);
% imshow(im2);
% 
% [X1,Y1]=ginput(4);
% [X2,Y2]=ginput(4);
close;

A = zeros(12,9);

j=1;
for i=1:4
    A(j,:) = [0 0 0 -X1(i) -Y1(i) -1 Y2(i)*X1(i) Y2(i)*Y1(i) Y2(i)*1];
    A(j+1,:) = [X1(i) Y1(i) 1 0 0 0 -X2(i)*X1(i) -X2(i)*Y1(i) -X2(i)];
    A(j+2,:) = [-Y2(i)*X1(i) -Y2(i)*Y1(i) -Y2(i)*1 X2(i)*X1(i) X2(i)*Y1(i) X2(i) 0 0 0];
    j=j+3;
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

% mapping im2 points on im1
inv2 = H \ [X_coords(:)';Y_coords(:)';ones(R*C,1)'];
normMat = repmat(inv2(3,:),3,1);
inv2 = inv2./normMat;

X_inv = reshape(inv2(1,:),R,C)';
Y_inv = reshape(inv2(2,:),R,C)';

canvas = zeros(C,R,3,'uint8');
canvas(:,:,1)=interp2(double(im2(:,:,1)),X_inv,Y_inv);
canvas(:,:,2)=interp2(double(im2(:,:,2)),X_inv,Y_inv);
canvas(:,:,3)=interp2(double(im2(:,:,3)),X_inv,Y_inv);
imshow(canvas);
% proj=zeros(round(max_y-min_y),round(max_x-min_x),3,'uint8');
% 
% for m=1:size2(1)
%     for n=1:size2(2)
%         inp = [m;n;1];
%         out = H*inp;
%         out = out/out(3);
%         row=round(out(1));
%         col=round(out(2));
%         
%         proj(row+y_off,col+2,:)=im2(m,n,:);
%     end
% end
% 
% imshow(proj);
% off_x=round(abs(X1(1)-X2(1)))+36;
% off_y=round(abs(Y1(1)-Y2(1)));