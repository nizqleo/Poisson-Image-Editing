function final_img=Function_of_seamless_tiling(src_img,row,col)
%% input and set the percentage
mid_rst_tile=src_img;
mid_tile=src_img;
if row==1
    mid_rst_tile=src_img;
else
    north_tile = src_img;
    south_tile = src_img;
    mid_tile  = src_img;
    north_tile(end,:,:) = (north_tile(end,:,:)/2 + south_tile(1,:,:)/2);
    south_tile(1,:,:) = north_tile(end,:,:);
    mid_tile(1,:,:) = north_tile(end,:,:);
    mid_tile(end,:,:) = north_tile(end,:,:); 
    north_tile = seamless_rect(src_img,north_tile);%北边这张南部有变色
    south_tile = seamless_rect(src_img,south_tile);%南边这张北部有变色
   	mid_tile = seamless_rect(src_img,mid_tile);
    for i=1:row-2
    north_tile=cat(1,north_tile,mid_tile);
    end
    mid_rst_tile=cat(1,north_tile,south_tile);
end

if col==1
    final_img=mid_rst_tile;
else
    east_tile = mid_rst_tile;
    west_tile = mid_rst_tile;
    mid_tile  = mid_rst_tile;
    east_tile(:,1,:) = (east_tile(:,1,:)/2 + west_tile(:,end,:)/2);
    west_tile(:,end,:) = east_tile(:,1,:);
    mid_tile(:,1,:) = west_tile(:,end,:);
    mid_tile(:,end,:) = mid_tile(:,1,:);
    east_tile = seamless_rect(mid_rst_tile,east_tile);
    west_tile = seamless_rect(mid_rst_tile,west_tile);
   	mid_tile = seamless_rect(mid_rst_tile,mid_tile);
    for i=1:col-2
    west_tile=cat(2,west_tile,mid_tile);
    end
    final_img=cat(2,west_tile,east_tile);
end




