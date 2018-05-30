function final_img = Function_of_texture_flattening(src_img)
%figure,imshow(src_img);
h = imfreehand;
%position = wait(h);
mask = double(createMask(h));
gray_img = rgb2gray(src_img);
edge_img = edge(gray_img,'canny');%����һ����������ͬ��С�Ķ�ֵ��ͼ��BW���ں�����⵽��Ե�ĵط�Ϊ1�������ط�Ϊ0��
[m, n, j] = size(src_img);%ɾ����j

H = [0 -1 0; -1 4 -1; 0 -1 0];
src_img = double(src_img);
grad_img = imfilter(src_img,H);

num_pixels = nnz(mask);
I = zeros(num_pixels,1);
J = zeros(num_pixels,1);

index_matr = zeros(m,n);
count=1;
for i=1:m
    for j=1:n
        if mask(i,j)==1
            I(count) = i;
            J(count) = j;
            index_matr(i,j) = count;
            count = count+1;
        end
    end
end

% create sparse matrix for each pixel,B��������������Ե�йصĵ���ݶ�ֵ���Լ�����Ե�ĵ��������ԭֵ֮��
Coeff_matr = spalloc(num_pixels,num_pixels,5*num_pixels);
B = zeros(num_pixels,3);

for i = 2:m-1
    for j = 2:n-1
        if mask(i,j) == 1
            
            for delta = -1:2:1
                if mask(i,j+delta) == 1
                    Coeff_matr(index_matr(i,j),index_matr(i,j+delta)) = -1; 
                else
                    for chnl=1:3
                        B(index_matr(i,j),chnl) = B(index_matr(i,j),chnl) + double(src_img(i,j+delta,chnl));%��ֹ���ر��
                    end
                end
                
                if mask(i+delta,j) == 1
                    Coeff_matr(index_matr(i,j),index_matr(i+delta,j)) = -1;
                else
                    for chnl = 1:3
                        B(index_matr(i,j),chnl) = B(index_matr(i,j),chnl) + double(src_img(i+delta,j,chnl));
                    end
                end
                
            end
            
  
            if edge_img(i,j) == 1
                for chnl=1:3
                    B(index_matr(i,j),chnl) = B(index_matr(i,j),chnl) + double(grad_img(i,j,chnl));%��ֹ���ر��
                end
            else
                for delta=-1:2:1
                    if edge_img(i+delta,j) == 1
                        for chnl=1:3
                            B(index_matr(i,j),chnl) = B(index_matr(i,j),chnl) + src_img(i,j,chnl) - src_img(i+delta,j,chnl);
                        end
                    end
                    
                    if edge_img(i,j+delta) == 1
                        for chnl=1:3
                            B(index_matr(i,j),chnl) = B(index_matr(i,j),chnl) + src_img(i,j,chnl) - src_img(i,j+delta,chnl);
                        end
                    end
                end
            end
            Coeff_matr(index_matr(i,j),index_matr(i,j)) = 4;
        end
    end
end

final_img = double(src_img);
solns = Coeff_matr\B;
for channel = 1:3
    for k = 1:num_pixels
        final_img(I(k),J(k),channel) = solns(k,channel);
    end
end
final_img = uint8(final_img);
end