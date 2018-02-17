function [U,B, lambda_U, lambda_B, y, r] =initFEMA(input, L_B, L_U, weight, r, U_cnt, B_cnt)

    % User-INIT
    U = zeros(U_cnt, r(1));
    
    % Construct X by mode-m matricization
    X = input;
    
    % Construct co-variance matrix C
    C = (X * transpose(X))+weight*L_U;

    % Compute Eigen-Values and Eigen-Vectors
    
    %[V,D,L] = svd(C);
    [V,D] = eig(C);
    
    [uselessVariable,permutation]=sort(diag(D), 'descend');
    %permutation
    D = D(permutation,permutation);
    V = V(:,permutation);
    U = V(:,1:r(1));
    lambda_U = D(1:r(1), 1:r(1));
    a.'
    new_r = 0;
    for i = 1:r(1)
        %lambda_U(i,i)
        if lambda_U(i,i) == 0 
            break;
        end
        new_r = new_r + 1;
    end
    
    r(1) = new_r;
    
    U = V(:,1:r(1));
    lambda_U = D(1:r(1), 1:r(1));
    
    %U = V(:,1:r(1));
    %lambda_U = D(1:r(1),1:r(1));
    
    
    % Behavior-Init
    B = zeros(B_cnt, r(2));
    
    % Construct X by mode-m matricization
    X = transpose(input);

    % Construct co-variance matrix C
    C = (X * transpose(X)) + weight*L_B;

    % Compute Eigen-Values and Eigen-Vectors

    %[V,D,L] = svd(C);

    %B = V(:,1:r(2));
    %lambda_B = D(1:r(2),1:r(2));
       
    [V,D] = eig(C);

    [uselessVariable,permutation]=sort(diag(D), 'descend');
    %permutation
    D = D(permutation,permutation);
    V = V(:,permutation);
    B = V(:,1:r(2));
    lambda_B = D(1:r(2), 1:r(2));
    
    new_r = 0;
    for i = 1:r(2)
        if lambda_B(i,i) == 0
            break;
        end
        new_r = new_r + 1;
    end
    
    r(2) = new_r;
    
    B = V(:,1:r(2));
    lambda_B = D(1:r(2), 1:r(2));
    
    %{
    % Word-Init
    
    W = zeros(W_cnt, r(3));
    
    % Construct X by mode-m matricization
    X = tens2mat(input,3);

    % Construct co-variance matrix C
    C = (X * transpose(X)) + ((weight) * L_W);

    % Compute Eigen-Values and Eigen-Vectors

    [V,D,L] = svd(C);

    W = V(:,1:r(3));
    lambda_W = D(1:r(3),1:r(3));
    %}
    
    
    
    y = input * B;
    y = transpose(U) * y;
   
    %{
    % Compute core-tensor
    
    y = ones(r(1),r(2),r(3));
    
    for b = 1:r(2)
        for k = 1:r(3)
            y(:,b,k) = (transpose(U) * squeeze(input(:,b,k)));
        end
    end
    
    size(y)
    for u=1:r(1)
       for k=1:r(3)
           y(u,:,k) = transpose(B)* transpose(squeeze(y(u,:,k)));
       end
    end
    
    %size(y)
    
    
    for u=1:r(1)
       for b=1:r(2)
           y(u,b,:) = transpose(W) * squeeze(y(u,b,:));
       end
    end
    
    
    %size(y)
    
    % y = (input * W);
    % y = cellfun(@(x) x*W,num2cell(input,[1 3]),'UniformOutput',false);
    % y = cat(3,y{:});
    %}