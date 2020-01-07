function [kernel_c1,kernel_f1] = init_kernel(layer_c1_num,layer_f1_num)
% initial the convolutional kernel
    for n = 1:layer_c1_num
        kernel_c1(:,:,n) = (2*rand(5,5)-ones(5,5))/12;
    end
    for n = 1:layer_f1_num
        kernel_f1(:,:,n) = (2*rand(12,12)-ones(12,12));
    end
end