function [error_probability, error_count] = Error_check(bit_vector1, bit_vector2)
    error_count = sum(bit_vector1 ~= bit_vector2);
    error_probability = error_count/length(bit_vector1);
end

