function [U_t_1, B_t_1, lambda_U_t_1, lambda_B_t_1, y] = evolutionaryAnalysis(input_t, d_input_t, U_t, B_t, lambda_U_t, lambda_B_t, r, U_cnt, B_cnt)

    lambda_U_t_1 = lambda_U_t;
    
    % User
    
    U_t_1 = zeros(U_cnt,r(1));
    
    %m = 1;
    
    
    X = input_t;
    d_X = d_input_t;
    %X = tens2mat(input_t, m);
    %d_X = tens2mat(d_input_t, m);
    for i = 1 : r(1)
        d_lambda =  transpose(U_t(:,i)) * ( (X * transpose(d_X)) + (d_X * transpose(X)) ) * U_t(:,i);
        lambda_U_t_1(i,i) = lambda_U_t(i,i)+d_lambda;
        d_lambda
        d_a = zeros(U_cnt, 1);
        
        for j = 1:r(1)
            if j == i
                continue
            end
            %size(((transpose(U_t(:,j)) * ( (X * transpose(d_X)) + (d_X * transpose(X)) ) * U_t(:,i)) / (lambda_U_t(i,i) - lambda_U_t(j,j))) * U_t(:,j))
            d_a = d_a + ((transpose(U_t(:,j)) * ( (X * transpose(d_X)) + (d_X * transpose(X)) ) * U_t(:,i)) / (lambda_U_t(i,i) - lambda_U_t(j,j))) * U_t(:,j);
        end
        
        U_t_1(:,i) = U_t(:,i)+d_a;
    end
    
    % Behavior
    B_t_1 = zeros(B_cnt,r(2));
    lambda_B_t_1 = lambda_B_t;
    %m = 2;
    
    X = transpose(input_t);
    d_X = transpose(d_input_t);
    for i = 1 : r(2)
        d_lambda =  transpose(B_t(:,i)) * ( (X * transpose(d_X)) + (d_X * transpose(X)) ) * B_t(:,i);
        %d_lambda
        lambda_B_t_1(i,i) = lambda_B_t(i,i)+d_lambda;
        
        d_a = zeros(B_cnt, 1);
        
        for j = 1:r(2)
            if j == i
                continue
            end
            
            d_a = d_a + ((transpose(B_t(:,j)) * ( (X * transpose(d_X)) + (d_X * transpose(X)) ) * B_t(:,i)) / (lambda_B_t(i,i) - lambda_B_t(j,j))) * B_t(:,j);
            
        end
        
        %d_a
        
        B_t_1(:,i) = B_t(:,i)+d_a;
    end
    
    %{
    % Words
    W_t_1 = zeros(W_cnt,r(3));
    lambda_W_t_1 = lambda_W_t;
    m = 3;
    
    X = tens2mat(input_t, m);
    d_X = tens2mat(d_input_t, m);
    for i = 1 : r(3)
        d_lambda =  transpose(W_t(:,i)) * ( (X * transpose(d_X)) + (d_X * transpose(X)) ) * W_t(:,i);
        lambda_W_t_1(i,i) = lambda_W_t(i,i)+d_lambda;
        
        d_a = zeros(W_cnt, 1);
        
        for j = 1:r(3)
            if j == i
                continue
            end
            
            d_a = d_a + ((transpose(W_t(:,j)) * ( (X * transpose(d_X)) + (d_X * transpose(X)) ) * W_t(:,i)) / (lambda_W_t(i,i) - lambda_W_t(j,j))) * W_t(:,j);
        end
        
        W_t_1(:,i) = W_t(:,i)+d_a;
    end
    
    
    % Core-Tensor
    
    % Compute core-tensor
    
    input_t = input_t+d_input_t;
    
    y = ones(r(1),r(2),r(3));
    
    for b = 1:r(2)
        for k = 1:r(3)
            y(:,b,k) = (transpose(U_t_1) * squeeze(input_t(:,b,k)));
        end
    end
    
    size(y)
    for u=1:r(1)
       for k=1:r(3)
           y(u,:,k) = transpose(B_t_1)* transpose(squeeze(y(u,:,k)));
       end
    end
    
    %size(y)
    
    
    for u=1:r(1)
       for b=1:r(2)
           y(u,b,:) = transpose(W_t_1) * squeeze(y(u,b,:));
       end
    end
    
    %}
    
    
    y = (input_t + d_input_t) * B_t_1;
    y = transpose(U_t_1) * y;
    
    % y = (input_t + d_input_t) * transpose(U_t_1) * transpose(B_t_1);