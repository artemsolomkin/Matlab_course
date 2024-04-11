function [de_bits] = demapping(IQ, Constellation)

[dictionary, bit_depth] = constellation_func(Constellation);

% Находим ближайшую точку созвездия

distances =abs(IQ - dictionary.');

[~, idx] = min(distances, [], 1);

de_bits = int2bit(idx-1, bit_depth);

de_bits = reshape(de_bits, 1, []);

end

