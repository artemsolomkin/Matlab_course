function bits = generateBits(constellation,Length_Bit_vector)

    [~, bit_depth_dict] = constellation_func(constellation);

    bits = randi([0 1], 1, Length_Bit_vector);

    % Вычисление количества нулей, необходимых для заполнения вектора битов.
    num_zeros = bit_depth_dict - mod(length(bits), bit_depth_dict);
    if num_zeros == bit_depth_dict
        num_zeros = 0;
    end
    
    % Дополнение вектора нулями
    bits = [bits zeros(1, num_zeros)];
end

