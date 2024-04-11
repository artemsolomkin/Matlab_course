function [MER] = MER_my_func(IQ_output, Constellation)

[dictionary, ~] = constellation_func(Constellation);

%нахождение идеальной точки для каждой точки на выходе
IQ_output_ideal = zeros(size(IQ_output));
for i = 1:length(IQ_output)
    min_distance = inf;
    min_index = 0;
    for j = 1:length(dictionary)
        distance = abs(IQ_output(i) - dictionary(j));
        if distance < min_distance
            min_distance = distance;
            min_index = j;
        end
    end
    IQ_output_ideal(i) = dictionary(min_index);
end

%Мощность для IQ
sum1=sum(real(IQ_output_ideal).^2+imag(IQ_output_ideal).^2);
%Мощность шума
sum2=sum(real(IQ_output_ideal-IQ_output).^2+imag(IQ_output_ideal-IQ_output).^2);
%MER itself
MER = 10 * log10(sum1 / sum2);
end