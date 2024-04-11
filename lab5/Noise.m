function IQ_output = Noise(SNR, IQ_input)
    % мощность сигнала
    IQ_inputPower = mean(abs(IQ_input).^2);
    % мощность шума
    NoisePower = IQ_inputPower / (10^(SNR/10));
    % белый шум с определенным SNR
    Noise = sqrt(NoisePower/2) * normrnd(0, 1, size(IQ_input)) + 1i * sqrt(NoisePower/2) * normrnd(0, 1, size(IQ_input));
    % добавление шума
    IQ_output = IQ_input + Noise;
end

