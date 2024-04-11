%% constellation_func
% Создаем словарь для разных созвездий
function [dictionary, bit_depth_dict] = constellation_func(Constellation)
    switch Constellation
        case 'BPSK'
            dictionary = [-1+0i 1+0i];
            bit_depth_dict = 1;
        case 'QPSK'
            dictionary = [-1-1i -1+1i 1-1i 1+1i];
            bit_depth_dict = 2;
        case '8PSK'
            angles = [5 4 2 3 6 7 1 0];
            dictionary = exp(1i*(angles*2*pi/8));
            bit_depth_dict = log2(8);
        case '16QAM'
            dictionary = [-3+3i, -3+1i, -3-3i, -3-1i, -1+3i, -1+1i, -1-3i, ... 
                -1-1i, 3+3i, 3+1i, 3-3i, 3-1i, 1+3i, 1+1i, 1-3i, 1-1i];
            bit_depth_dict = 4;
    end
 % Нормировка:
 N=size(dictionary,2);
 norm = sqrt(sum(dictionary .* conj(dictionary))/N);
 dictionary = dictionary./norm;

end
