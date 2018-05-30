function final_img =Function_of_monochrome_transfer(src_img,dst_img,handles)
%% Inputs 
%src_img = imresize(src_img,0.6);%适当调整大小
%src_img = src_img(:,end:-1:1,:);%翻转
%[m, n, x] = size(src_img);
%% Select area in the background image

axes(handles.axes1);
h=imfreehand;
api = iptgetapi(h);

%定义一个矩形框区域限制函数，这个函数使得矩形框被限制在图像内部，不能被挪到图像外部。
fcn = makeConstrainToRectFcn('imfreehand',[1 size(src_img,2)],[1 size(src_img,1)]);

api.setPositionConstraintFcn(fcn);
%position = wait(h);
mask = double(createMask(h));
%% Crop the background image and set the border of mask as 0

cc = regionprops(mask,'BoundingBox');%包含相应区域的最小矩形
mask = imcrop(mask,cc(1).BoundingBox);
mask(1,:) = 0;
mask(end,:) = 0;
mask(:,1) = 0 ;
mask(:,end) = 0;
src_img = imcrop(src_img,cc(1).BoundingBox);
%[m, n, x] = size(src_img);
% figure,imshow(src_img);
% figure,imshow(mask);
%% Select the area in the target image and resize the background image

% subplot(1,2,1);
% imshow(src_img),hold on;
% plot(position(:,1),position(:,2))
% subplot(1,2,2);
axes(handles.axes2);
h2 = imrect(gca,[1 1 size(mask,2) size(mask,1)]);% gca表示当前的图
setFixedAspectRatioMode(h2,1);%固定长宽比
fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));%这个选择框的大小也限制可变
setPositionConstraintFcn(h2,fcn); 
position2 = wait(h2); %左上角坐标，宽度，高度

mask = imresize(mask,[position2(4) position2(3)]);
mask = mask > 0;
src_img = imresize(src_img,[position2(4) position2(3)]);
mask(1,:) = 0;
mask(end,:) = 0;
mask(:,1) = 0 ;
mask(:,end) = 0;
[m, n] = size(src_img);% 删掉了x
%% Row shift and col shift


row_shift = floor(position2(2));
col_shift = floor(position2(1));

%% Create the X,Y coordinates vectors and the index vector
%%坐标矢量和索引矢量


num_points = nnz(mask); % size of Coeff Matrix
I = zeros(num_points,1);
J = zeros(num_points,1);

count=1;
for i=1:m
    for j=1:n
        if mask(i,j) == 1
            I(count) = i;
            J(count) = j;
            count = count+1;
        end
    end
end

index_matr = zeros(m,n);
count = 1;

for i = 1:num_points
   y = I(i);
   x = J(i);
   index_matr(y,x) = count;
   count = count + 1;
end

%% calculate laplacian at each point in source image

gackground_img = rgb2gray(src_img);%转灰度图
src_img(:,:,1) = gackground_img;
src_img(:,:,2) = gackground_img;
src_img(:,:,3) = gackground_img;
src_img = double(src_img);
H = [0 -1 0; -1 4 -1; 0 -1 0];
grad_img = imfilter(src_img,H);

%% Initialise the A and B matrices

Coeff_matr = spalloc(num_points,num_points,5*num_points);
B = zeros(num_points,3);

%% Fill the A,B matrix   B它包含原图中四邻域的像素值和融合素材的梯度值
for y = 2:m-1
    for x = 2:n-1  
        % only add points that are in mask
        if mask(y,x) == 1
            neighbours = 1;
            % take care of neighbors
            % top boundary
            if mask(y-1,x) == 1
                Coeff_matr(index_matr(y,x),index_matr(y-1,x)) = -1;
                neighbours = neighbours+1;
            else
                for chnl=1:3
                    B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(dst_img(y-1+row_shift,x+col_shift,chnl));
                end
            end
            
            % left boundary
            if mask(y,x-1) == 1
                Coeff_matr(index_matr(y,x),index_matr(y,x-1)) = -1;
                neighbours = neighbours+1;
            else
                for chnl =1:3
                    B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(dst_img(y+row_shift,x-1+col_shift,chnl));
                end
            end
            
            % bottom boundary
            if mask(y+1,x) == 1
                Coeff_matr(index_matr(y,x),index_matr(y+1,x)) = -1;
                neighbours = neighbours+1;
            else
                for chnl=1:3
                    B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(dst_img(y+1+row_shift ,x+col_shift,chnl));
                end
            end
            
            % right boundary
            if mask(y,x+1) == 1
                Coeff_matr(index_matr(y,x),index_matr(y,x+1)) = -1;
                neighbours = neighbours+1;
            else
                for chnl=1:3
                    B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + double(dst_img(y + row_shift ,x+1+col_shift,chnl));
                end
            end
            
            for  chnl =1:3
                disp([y,x])
                B(index_matr(y,x),chnl) = B(index_matr(y,x),chnl) + grad_img(y,x,chnl);
            end
            Coeff_matr(index_matr(y,x),index_matr(y,x)) = 4;
        end
    end
end
%% Solving AX = B

final_img = double(dst_img);
solns = Coeff_matr\B;
for k = 1:num_points
    final_img(I(k)+row_shift,J(k)+col_shift,:) = solns(k,:);
end
%% Outputs
final_img = uint8(final_img);
end