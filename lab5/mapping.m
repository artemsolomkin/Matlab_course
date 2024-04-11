function [IQ] = mapping(bits, constellation)

    [dictionary, bit_depth] = constellation_func(constellation);
    
    symbols_index = reshape(bits, bit_depth, []).';
    
    symbols_index = bi2de(symbols_index, 'left-msb');
    
    IQ = dictionary(symbols_index+1);

end