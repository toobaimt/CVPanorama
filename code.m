im1 = imread('view1.png');
im2 = imread('view2.png');
size1 = size(im1);
size2 = size(im2);
%imshow(im1);
%[X1 Y1]=ginput;
%figure;
%imshow(im2);
%[X2 Y2]=ginput;
X1=[1,3,15,9];
Y1=[1,2,13,4];
X2=[5,7,18,11];
Y2=[5,16,7,8];
A = ones(8,9);

j=1;
for i=1:4
A(j,:) = [0 0 0 -X1(i) -Y1(i) -1 Y2(i)*X1(i) Y2(i)*Y1(i) Y2(i)*1];
A(j+1,:) = [X1(i) Y1(i) 1 0 0 0 -X2(i)*X1(i) -X2(i)*Y1(i) -X2(i)];
j=j+2;
end

[U S V] = svd(A);
h = V(:,9);
H = ones(3,3);
H(1,:)=h(1:3)';
H(2,:)=h(4:6)';
H(3,:)=h(7:9)';
test=H*[X1(1);Y1(1);1];