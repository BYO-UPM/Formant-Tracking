function cepCoeffs = fb2cpz(F, Fbw, Z, Zbw, cepOrder, fs)

% Convert center frequencies/bandwidths of BOTH resonances and
% anti-resonances to a specified number of cepstral coefficients. Extension
% of equation in Interspeech 2007 paper (which should have had 2/n and
% negative sign in exp() [fb2cp.m]. Handles no zeros or no poles.
%
% INPUT
%   F - center frequencies of resonances, Hz ([] if none), 
%       numFormants x numObs
%   Fbw - bandwidths of resonances, Hz ([] if none),
%       numFormants x numObs
%   Z - center frequencies of anti-resonances, Hz ([] if none),
%       numAntiformants x numObs
%   Zbw - bandwidths of anti-resonances, Hz ([] if none),
%       numAntiformants x numObs
%   cepOrder - Number of Cepstral Coefficients to use,
%       cepOrder x numObs
%   fs - sampling rate, Hz
%
% OUTPUT
%   cepCoeffs - cepstral coefficients, starting with C1
% 
% Author: Daryush Mehta
% Created : 4/23/10
% Modified: 4/26/10 (handle no zero or no pole input)

% for kk = 1:length(cepOrder)
%     cepCoeffs = fb2cp(F(kk),Fbw(kk),cepOrder,fs); % LPCC coeffs due to poles
%     cepCoeffs = cepCoeffs - fb2cp(Z(kk),Zbw(kk),cepOrder,fs); % Adjust due to effect of zeros
% end
% 
% cepCoeffs=cepCoeffs';

C_int = zeros(cepOrder,length(F));
C_int2 = zeros(cepOrder,length(Z));
cepCoeffs = zeros(1,cepOrder);

for n = 1:cepOrder
    if ~length(F) == 0 % if resonances present
        for i = 1:length(F)
            bw_term = exp(-pi*n*(Fbw(i)/fs));
            C_int(n,i) = bw_term*cos(2*pi*n*F(i)/fs);
        end
    end
    
    if ~length(Z) == 0 % if anti-resonances present
        for j = 1:length(Z)
            bw_term = exp(-pi*n*(Zbw(j)/fs));
            C_int2(n,j) = bw_term*cos(2*pi*n*Z(j)/fs);
        end
    end

    cepCoeffs(n) = (2/n)*(sum(C_int(n,:))-sum(C_int2(n,:)));
end