%% plot center frequency and bandwidth tracks on spectrogram assuming
%% Wavesurfer-type input (only formants and bandwidths, no antiformants)

function [] = plotSpecTracksWS(audio, f, bw, aParams)

fs = aParams.fs;
wLength = aParams.wLength;
wOverlap = aParams.wOverlap;

% Spectrogram Code
if wOverlap == 0
    winlen = wLength;
    winlen = winlen + (mod(winlen,2)~=0); % force even
    winoverlap = wOverlap;
else
    winlen = floor(fs/1000*8);  % 8 ms to make plots clear
    winlen = winlen + (mod(winlen,2)~=0); % force even
    winoverlap = round(0.95*winlen);
end
lineW = 1.5;
Fcolor = 'b';

%%
figure;
[B, freq, t] = specgram(audio,512,fs,hamming(winlen),winoverlap);
imagesc(t,freq,20*log10(abs(B))), axis xy
% [S,F,T,P] = spectrogram(audio,hamming(winlen),winoverlap,256,fs);
% surf(T,F,10*log10(abs(P)), 'EdgeColor', 'None');
% view(0, 90)
% grid off
axis tight, box off
colormap(flipud(gray(256)))
colorbar EastOutside
rangemax = max(max(20*log10(abs(B))));
set(gca, 'CLim', [rangemax-60 rangemax])
xlabel('Time (s)'), ylabel('Frequency (Hz)'), title('Tracks of formants (blue) and anti-formants (red)')
hold on;

%%
if wOverlap == 0, xScale = wLength/fs; else xScale = 1/fs*wLength*wOverlap; end
xStart = xScale/2;
xInd = xStart:xScale:xStart+xScale*(size(f,2)-1);
len = size(f,2);

xdata = xInd(1:len);
numF = size(f,1);
for ii = 1:numF
    trackF = f(ii,:);
    trackBW = bw(ii,:);
    L = trackF-trackBW/2;
    U = trackF+trackBW/2;
    fill([xdata xdata(end:-1:1)], [L U(end:-1:1)], Fcolor, 'EdgeColor', 'none', 'FaceAlpha', 0.3)
    plot(xdata,trackF,Fcolor,'LineWidth',lineW);
end

format_plot