close all; clear; clc;
%% Options of the model
Length_Bit_vector = 1e6;
rng(321);

Constellation = "8PSK"; % BPSK, QPSK, 8PSK, 16QAM

SNR = 30; % dB

%% Bit generator

Bit_input = generateBits(Constellation,Length_Bit_vector);

%% Mapping

IQ_input = mapping(Bit_input, Constellation);
[dictionary, bit_depth_dict] = constellation_func(Constellation);
points = linspace(0, 2^bit_depth_dict - 1, 2^bit_depth_dict);
bit_depth_dict = dec2bin(points);
%% Channel

Eb_N0 = Eb_N0_convert(SNR, Constellation);

IQ_output = Noise(SNR, IQ_input);

figure;
plot(IQ_output, '.');
text(real(dictionary) + 0.1, imag(dictionary) + 0.1, bit_depth_dict);
%% Demapping
Bit_output = demapping(IQ_output, Constellation);

%% Error check

BER = Error_check(Bit_input, Bit_output);

%% Experimental BER(SNR) and BER(Eb/N0)

constellations = ["BPSK", "QPSK", "8PSK", "16QAM"];

SNR = -40:0.05:20;
BERt_all=zeros(size(SNR,2),size(constellations,2));
BERm_all=zeros(size(SNR,2),size(constellations,2));
Merm_all=zeros(size(SNR,2),size(constellations,2));

EbN0_all=zeros(size(SNR,2),size(constellations,2));


for p = 1:length(constellations)
    Constellation = constellations{p};
    Bit_Tx = generateBits(Constellation,Length_Bit_vector);
    IQ_TX = mapping(Bit_Tx, Constellation);

    EbN0 = Eb_N0_convert(SNR, Constellation);
    BERm = zeros(size(SNR));
    MERm=  zeros(size(SNR));
    tic
    parfor i = 1:length(SNR)
        IQ_RX = Noise(SNR(i), IQ_TX);
        %IQ_RX= awgn(IQ_TX,SNR(i),'measured');
        Bit_Rx = demapping(IQ_RX, Constellation);
        BERm(i) = Error_check(Bit_Tx, Bit_Rx);
        MERm(i) = MER_my_func(IQ_RX, Constellation);
    end
    toc
    BERm_all(:,p)=BERm;
    EbN0_all(:,p)=EbN0;
    Merm_all(:,p)=MERm;

    figure('Position', [100 0 1720 500]);
    subplot(1, 2, 1);

    plot(SNR, BERm,'r','LineWidth',1.5);
    hold on;
    plot(EbN0, BERm,'b','LineWidth',1.5);
    hold on;
    
    %NOTE: using qfunc is also possible here
    switch Constellation
    case "BPSK"
        EbN0_c = 10.^(EbN0/10);
        BERt = 1/2.*erfc(sqrt(EbN0_c));
    case "QPSK"
        EbN0_c = 10.^(EbN0/10);
        BERt = 1/2.*erfc(sqrt(EbN0_c));
    case "8PSK"
        EbN0_c = 10.^(EbN0/10);
        BERt = 1/3.*erfc(sqrt(3.*EbN0_c)*sin(pi/8));

    case  "16QAM"
        EbN0_c = 10.^(EbN0/10);

        BERt = 2/log2(16)*(1-1/sqrt(16)).*erfc(sqrt(3*log2(16)/(2*(16-1)).*EbN0_c));

    otherwise
        disp('incorrect const')
    end

    BERt_all(:,p)=BERt;
    plot(EbN0, BERt,'g','LineWidth',1.5);
    hold on;
    legend('Зависимость BER от SNR','Экспериментальный BER от Eb/N0', ...
        'Теоретический BER от Eb/N0', 'Location','southwest');
    set(gca, 'YScale', 'log');
    title(['Зависимости для ' Constellation]);
    grid on;
    xlabel('SNR/Eb_N0 (dB)');
    ylabel('BER');
    ylim([10^(-5) 10^(0)]);
    xlim([-10 20]);

end
%% Additional task
figure();
plot(EbN0_all(:,1), BERm_all(:,1),'m','LineWidth',2);
hold on;
plot(EbN0_all(:,2), BERm_all(:,2),'c','LineWidth',2);
hold on;
plot(EbN0_all(:,3), BERm_all(:,3),'b','LineWidth',2);
hold on;
plot(EbN0_all(:,4), BERm_all(:,4),'k','LineWidth',2);
legend("BPSK", "QPSK", "8PSK", "16QAM", 'Location','southwest');
set(gca, 'YScale', 'log');
xlabel('Eb/N0 (dB)');
ylabel('BER');
title('Зависимость BER от Eb/N0 для ' + strjoin(constellations,', '));
grid on;
hold on;
name="BER(Eb_N0).png";
xlim([-10 30]);
saveas(gcf,name);
saveas(gcf,"BER(Eb_N0).fig");

figure();
plot(SNR, BERm_all(:,1),'m','LineWidth',2);
hold on;
plot(SNR, BERm_all(:,2),'c','LineWidth',2);
hold on;
plot(SNR, BERm_all(:,3),'b','LineWidth',2);
hold on;
plot(SNR, BERm_all(:,4),'k','LineWidth',2);
legend("BPSK", "QPSK", "8PSK", "16QAM", 'Location','southwest');
set(gca, 'YScale', 'log');
xlabel('SNR (dB)');
ylabel('BER');
title('Зависимость BER от SNR для ' + strjoin(constellations,', '));
grid on;
hold on;
name="BER(SNR).png";
xlim([-10 30]);
saveas(gcf,name);

figure();
plot(SNR, abs(Merm_all(:,1).'-SNR),'m','LineWidth',2);
hold on;
plot(SNR, abs(Merm_all(:,2).'-SNR),'c','LineWidth',2);
hold on;
plot(SNR, abs(Merm_all(:,3).'-SNR),'b','LineWidth',2);
hold on;
plot(SNR, abs(Merm_all(:,4).'-SNR),'k','LineWidth',2);
legend("BPSK", "QPSK", "8PSK", "16QAM", 'Location','northwest');
xlabel('SNR (dB)');
ylabel('Error(MERm-SNR)');
title('Ошибка между SNR и MER для ' + strjoin(constellations,', '));
grid on;
hold on;
name="MER(SNR).png";
saveas(gcf,name);
saveas(gcf,"MER(SNR).fig");
