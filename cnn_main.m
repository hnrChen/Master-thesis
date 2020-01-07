% initial the network
layer_c1_num = 20;   % number of note of the first convolution layer
layer_s1_num = 20;   %
layer_f1_num = 100;  % number of note of the first convolution layer
layer_output_num = 10;  % number of note of the output layer
% Weight adjustment step
yita = 0.01;
% initial the bias
bias_c1 = (2*rand(1,20)-ones(1,20))/sqrt(20);
bias_f1 = (2*rand(1,100)-ones(1,100))/sqrt(20);
% initial the convolutional kernel
[kernel_c1,kernel_f1] = init_kernel(layer_c1_num,layer_f1_num);
% initial the pooling kernel
pooling_a = ones(2,2)/4;
% weights of the fully connected layer
weight_f1 = (2 * rand(20,100) - ones(20,100)) / sqrt(20);
weight_output = (2 * rand(100,10) - ones(100,10)) / sqrt(100);

% network training start
for iter = 1:20
    for n = 1:20
        for m = 0:9   % m and n are location of the input signal(input samples)
            % load the sampls
            train_data = imread(strcat(num2str(m),'_',num2str(n),'.bmp'));
            train_data = double(train_data);
            % delete the mean value
    %       train_data=wipe_off_average(train_data);
            % convolutional layer 1
            for k = 1:layer_c1_num
                state_c1(:,:,k) = convolution(train_data,kernel_c1(:,:,k));
                % activation function
                state_c1(:,:,k) = ReLU(state_c1(:,:,k) + bias_c1(1,k));
                % pooling layer 1
                state_s1(:,:,k) = pooling(state_c1(:,:,k),pooling_a);
            end
            
            for i = 1:4
                % batch normalization
                for j = 1:layer_c2_num
                    
            
            % fully connected layer
            [state_f1_pre,state_f1_temp] = convolution_f1(state_s1,kernel_f1,weight_f1);
            % activation function
            for nn = 1:layer_f1_num
                state_f1(1,nn) = tanh(state_f1_pre(:,:,nn) + bias_f1(1,nn));
            end
            % softmax layer
            for nn = 1:layer_output_num
                output(1,nn) = exp(state_f1 * weight_output(:,nn)) / sum(exp(state_f1 * weight_output));
            end
            % calculated the error
            Error_cost = -output(1,m + 1);
%           if (Error_cost<-0.98)
%               break;
%           end
            % adjust the parameter
            [kernel_c1,kernel_f1,weight_f1,weight_output,bias_c1,bias_f1] = CNN_upweight(yita,Error_cost,m,train_data,...
                                                                                                state_c1,state_s1,...
                                                                                                state_f1,state_f1_temp,...
                                                                                                output,...
                                                                                                kernel_c1,kernel_f1,weight_f1,weight_output,bias_c1,bias_f1);
        end
    end
end


% finish the training part and the start the validation part
count = 0;
for n = 1:20
    for m = 0:9
        % load the samples
        train_data = imread(strcat(num2str(m),'_',num2str(n),'.bmp'));
        train_data = double(train_data);
        % delete the mean value
%       train_data=wipe_off_average(train_data);
        % convolutional layer
        for k = 1:layer_c1_num
            state_c1(:,:,k) = convolution(train_data,kernel_c1(:,:,k));
            % activation function 1
            state_c1(:,:,k) = tanh(state_c1(:,:,k)+bias_c1(1,k));
            % pooling layer 1
            state_s1(:,:,k) = pooling(state_c1(:,:,k),pooling_a);
        end
        % fully connected layer
        [state_f1_pre,state_f1_temp] = convolution_f1(state_s1,kernel_f1,weight_f1);
        % activation function
        for nn = 1:layer_f1_num
            state_f1(1,nn) = tanh(state_f1_pre(:,:,nn)+bias_f1(1,nn));
        end
        % softmax layer
        for nn = 1:layer_output_num
            output(1,nn) = exp(state_f1*weight_output(:,nn))/sum(exp(state_f1*weight_output));
        end
        [p,classify] = max(output);
        if (classify == m+1)
            count = count+1;
        end
        fprintf('true number%d  network output%d  probability%d \n',m,classify-1,p);
    end
end
