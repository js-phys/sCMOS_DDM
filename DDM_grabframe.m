function [ img ] = DDM_grabframe( fnumber, signal, fsize, width, height)  
%DDMGRABFRAME Grab a frame within a .sifx file.

[rc,tmp]=atsif_getframe(signal,fnumber,fsize);
if rc~=22002
    error('Error. \nInput must be a char, not a %s.',class(n))
end
    img = rot90(reshape(tmp,width,height));
    
end

