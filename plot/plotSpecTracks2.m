% varargin -- numAntiF, trackBW
% corrected xStart to half window length (does not depend on xScale)

function [] = plotSpecTracks2(audio, tracks, aParams, varargin)

fs = aParams.fs;
wLength = aParams.wLength;
wOverlap = aParams.wOverlap;

% Spectrogram Code
winlen = floor(fs/1000*4);  % 4 ms to make plots clear
winlen = winlen + (mod(winlen,2)~=0); % force even
winoverlap = winlen-1; % 50pct overlap

figure;
specgram(audio,512,fs,hamming(winlen),winoverlap);
axis xy, colormap(flipud(pink(128)))
axis tight, box off
xlabel('Time (s)'), ylabel('Frequency (Hz)'), title('Tracks of formants (yellow) and antiformants (cyan)')
hold on;

xScale = 1/fs*wLength*wOverlap;
xStart = wLength/fs/2;
xInd = xStart:xScale:xStart+xScale*(size(tracks(1,:,1),2)-1);
len = size(tracks,2);

xdata = xInd(1:len);

switch length(varargin)
    case 0
        plot(xdata,tracks(:,1:len,1)','y');
    case 1
        numAntiF = varargin{1};
        plot(xdata,tracks(1:end-numAntiF,1:len,1)','y');
    
        if numAntiF
            plot(xdata,tracks(end-numAntiF+1:end,1:len,1)','c');
        end
    case 2
        numAntiF = varargin{1};
        trackBW = varargin{2};

        if trackBW
            plot(xdata,tracks(1:(end-2*numAntiF)/2,1:len,1)','y');

            if numAntiF
                plot(xdata,tracks(end-2*numAntiF+1:end-numAntiF,1:len,1)','c');
            end            
        else
            plot(xdata,tracks(1:end-numAntiF,1:len,1)','y');

            if numAntiF
                plot(xdata,tracks(end-numAntiF+1:end,1:len,1)','c');
            end
        end
    otherwise
        disp('Incorrect inputs into plotSpecTracks2().')
end

set(findobj('Type','line'),'LineWidth',2)