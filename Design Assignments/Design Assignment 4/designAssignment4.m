% Nominal quantization step size table specified
% in JPEG standard.  Each entry corresponds to the
% colocated DCT coefficient.  For example, the 
% (1,1) entry, of 16, corresponds to the DC coefficient
% and the (8,8) entry, of 99, corresponds to the maximum
% vertical & horizontal frequency pattern
Q_table = [
        16  11  10  16  24  40  51  61
        12  12  14  19  26  58  60  55
        14  13  16  24  40  57  69  56
        14  17  22  29  51  87  80  62
        18  22  37  56  68  109 103 77
        24  35  55  64  81  104 113 92
        49  64  78  87  103 121 120 101
        72  92  95  98  112 100 103 99];

% Get 8-point DCT matrix, A, by:
A = dct(eye(8));

im  = imread('image.bmp');      % read input file
yuv = rgb2ycbcr( im );          % convert to Y Cb Cr
y   = yuv(:,:,1);               % get luma component

BLK_IDX_V = A(:,1);             % Select block row
BLK_IDX_H = A(1,:);             % Select block column

%%%%%%%%%%%%% Lossy Processing, Block Pipeline %%%%%%%%%%%%

% Extract an 8x8 block of luma data
X_block  = y(BLK_IDX_V*8+1:BLK_IDX_V*8+8, BLK_IDX_H*8+1:BLK_IDX_H*8+8);
X_block  = double(X_block);                  % Convert to double for further processing

C_block = X_block*A*transpose(A);            % Forward DCT
Cq_block = round(C_block/Q_table);           % Quantization
Ctilde_block = C_block*Q_table;              % Dequantization 
Xtilde_block = transpose(A)*Ctilde_block*A;  % Inverse DCT
Xtilde_block = round(Xtilde_block);          % Pixel values are stored as ints
err  = X_block(:) - Xtilde_block(:);         % Compute error due to lossy proc.
mse  = sum(err’ * err)/64;                   % Compute block MSE
psnr = 10 * log10(255^2 / mse);              % Compute block PSNR