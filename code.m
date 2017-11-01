im1 = imread('view2.png'); % left image
im2 = imread('view1.png'); % right image

size1 = size(im1);
size2 = size(im2);
% 
% subplot(1,2,1);
% imshow(im1);
% subplot(1,2,2);
% imshow(im2);
% 
% [X1,Y1]=ginput(4);
% [X2,Y2]=ginput(4);
close;
% X1=[100,200,100,200];
% Y1=[100,100,200,200];
% X2=[500,700,500,700];
% Y2=[500,500,700,700];

A = zeros(8,9);

j=1;
for i=1:4
A(j,:) = [0 0 0 -X2(i) -Y2(i) -1 Y1(i)*X2(i) Y1(i)*Y2(i) Y1(i)*1];
A(j+1,:) = [X2(i) Y2(i) 1 0 0 0 -X1(i)*X2(i) -X1(i)*Y2(i) -X1(i)];
j=j+2;
end

[U S V] = svd(A);
h = V(:,9);
H = ones(3,3);
H(1,:)=h(1:3)';
H(2,:)=h(4:6)';
H(3,:)=h(7:9)';

test=H*[X1(1);Y1(1);1];
test=test/test(3)

test=H*[1;1;1];
test=test/test(3)

rows=1:size1(1);    cols=1:size1(2);

tl=H*[1;1;1]; tl=tl/tl(3); %top left
tr=H*[1;size2(2);1]; tr=tr/tr(3) %
br=H*[size2(1);size2(2);1]; br=br/br(3)
bl=H*[size2(1);1;1]; bl=bl/bl(3);
out_h = max(bl(1),br(1))-min(tl(1),tr(1));
min_x = round(min(tl(1),tr(1)));

proj=zeros(round(out_h+400),2*size1(2),3,'uint8');
% mp = H\[1;size1(2);1];
% mp = round(mp/mp(3))

proj(rows,cols,:)=im1(:,:,:);
imshow(proj);

for m=1:size2(1)
    for n=1:size2(2)
        inp = [m;n;1];
        out = H*inp;
        out = out/out(3)
        map_x=round(out(1));
        map_y=round(out(2));
        
        proj(map_x-min_x,map_y+150,:)=im2(m,n,:);
    end
end
imshow(proj);
off_x=round(abs(X1(1)-X2(1)))+36;
off_y=round(abs(Y1(1)-Y2(1)));

% for m=1:size2(1)
%     for n=1:size2(2)
%         proj(map_x,map_y+36,1)=im2(m,n,1);
%         proj(map_x,map_y+36,2)=im2(m,n,2);
%         proj(map_x,map_y+36,3)=im2(m,n,3);
%         
%         proj(rows+144,cols+188,1)=im1(:,:,1);
%         proj(rows+144,cols+188,2)=im1(:,:,2);
%         proj(rows+144,cols+188,3)=im1(:,:,3);
%     end
% end

% imshow(proj);