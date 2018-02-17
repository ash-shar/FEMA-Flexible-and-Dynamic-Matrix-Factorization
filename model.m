function [] = model(dataset)
dataset
basepath = strcat('FEMA-Input/', dataset);
basepath = strcat(basepath, '/');
%B_cnt = 5*10;

filename = strcat(basepath, strcat('0','.txt'));

input = dlmread(filename,'\t');

%input = reshape(input, [], B, T);

%[U_cnt, x] = size(input);

% input = mat2tens(input, [U_cnt B_cnt T_cnt], 1);

[U_cnt, B_cnt]= size(input);
l_u_filename = strcat(basepath, 'L_U.txt');

l_w_filename = strcat(basepath, 'L_WT.txt');

L_U = dlmread(l_u_filename, '\t');
L_W = dlmread(l_w_filename, '\t');

%L_W = L_W*100;
%L_U = L_U*100;

[U,B, lambda_U, lambda_B, y, r] = initFEMA(input, L_W, L_U, 0.3, [50 10], U_cnt, B_cnt);
r

for t = 2:5
    
    last_input = input;

    filename = strcat(basepath, strcat(int2str(t-1),'.txt'));

    input = dlmread(filename,'\t');
    
    %input = reshape(input, [], B, T);

    d_input = input-last_input;
    
    [U_cnt, B_cnt]= size(input);
    %B
    [U_t_1, B_t_1, lambda_U_t_1, lambda_B_t_1, y_t_1] = evolutionaryAnalysis(input, d_input, U, B, lambda_U, lambda_B, r, U_cnt, B_cnt);
    
    U = normc(U_t_1);
    B = normc(B_t_1);
    %W = W_t_1;
    lambda_U = lambda_U_t_1;
    lambda_B = lambda_B_t_1;
    %lambda_W = lambda_W_t_1;
    
    

    %size(y)
end

destpath = strcat('FEMA-Output/', dataset);

destpath = strcat(destpath, '/');

filename = strcat(destpath,'U.txt');
dlmwrite(filename,U,'\t');

filename = strcat(destpath,'B.txt');
dlmwrite(filename,B,'\t');

filename = strcat(destpath,'lambda_U.txt');
dlmwrite(filename,lambda_U,'\t');

filename = strcat(destpath,'lambda_B.txt');
dlmwrite(filename,lambda_B,'\t');

filename = strcat(destpath,'y.txt');
dlmwrite(filename,y,'\t');