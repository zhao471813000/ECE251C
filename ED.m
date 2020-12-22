function im_out=ED(im)
%%compute the gradient magnitude and gradient direction
im1=double(im);
k_x=[-1,0,1;-2,0,2;-1,0,1];
k_y=[-1,-2,-1;0,0,0;1,2,1];
G_x=conv2(im,k_x,'same');
G_y=conv2(im,k_y,'same');
G0=atan2(G_y,G_x)*180/pi;
G=sqrt(G_x.^2+G_y.^2);
r=size(im,1);
c=size(im,2);
G1=zeros(r,c);
for i=1:r
    for j=1:c
        if G0(i,j)<0
            G0(i,j)=360+G0(i,j);
        end
    end
end
for i=1:r
    for j=1:c
        if G0(i,j)>=0 && G0(i,j)<22.5 || G0(i,j)>=157.5 && G0(i,j)<202.5 || G0(i,j)>=337.5 && G0(i,j)<=360
            G0(i,j)=0;
        elseif G0(i,j)>=22.5 && G0(i,j)<67.5|| G0(i,j)>=202.5 || G0(i,j)< 247.5
            G0(i,j)=45;
        elseif G0(i,j)>=67.5 && G0(i,j)< 112.5 || G0(i,j)>= 247.5 && G0(i,j)<292.5
            G0(i,j)=90;
        elseif G0(i,j)>=112.5 && G0(i,j)< 157.5 || G0(i,j)>=202.5 && G0(i,j)< 337.5
            G0(i,j)=135;
        end
    end
end
%% Apply non maximum suppression

NMS=zeros(r,c);
for i=2:r-1
    for j=2:c-1
        if G0(i,j)==0
          NMS(i,j)=(G(i,j)==max([G(i,j),G(i,j+1),G(i,j-1)]));
        elseif G0(i,j)==45
          NMS(i,j)=(G(i,j)==max([G(i,j),G(i+1,j-1),G(i-1,j+1)]));
        elseif G0(i,j)==90
          NMS(i,j)=(G(i,j)==max([G(i,j),G(i+1,j),G(i-1,j)]));
        elseif G0(i,j)==135
          NMS(i,j)=(G(i,j)==max([G(i+1,j+1),G(i-1,j-1),G(i,j)]));
        end
    end
end
NMS=uint8(NMS.*G);
%figure
%imshow(NMS);
%% thresholding
tl=0.1;
im_out=zeros(r,c);
for i=1:r
    for j=1:c
    if NMS(i,j)>=tl
        im_out(i,j)=1;
        else im_out(i,j)=0;
        end
    end
end
end

