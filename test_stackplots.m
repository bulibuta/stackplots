% Copyright (c) 2017 Paul Irofti <paul@irofti.net>
% 
% Permission to use, copy, modify, and/or distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.
% 
% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

%% Test stackplots
clear; clc; close all; fclose all; format compact;
%%-------------------------------------------------------------------------
m = 4;          % number of subplot rows
n = 3;          % number of subplot columns
curves = 7;     % number of curves on each subplot
K = 100;        % number of datapoints on each curve
%%-------------------------------------------------------------------------
data = randn(m,n,curves,K);    % random plot data
color = ['y', 'm', 'c', 'r', 'g', 'b', 'k'];

subplot(m,n,1)
splot = zeros(m*n,1);
iplot = 1;
for i = 1:m
    for j = 1:n
        splot(iplot) = subplot(m,n,iplot);

        %% Do the real figure
        for up = 1:curves
            plot(1:K, squeeze(data(i,j,up,1:K)), color(up), 'Linewidth', 1);
            hold on;
        end
        xticks(0:20:K);
        grid on;
        hold off;
        iplot = iplot+1;
    end
end

% Original
f = copyobj(gcf,0);

% Test legend placement
f1 = copyobj(f,0);
lgd = legend(mat2cell('a':char('a'+curves-1), 1, ones(curves, 1)));
stackplots(f1,m,n);

% Test xlabel
f2 = copyobj(f,0);
stackplots(f2,m,n,'xlabel','Iterations');

% Test ylabel
f3 = copyobj(f,0);
stackplots(f3,m,n,'ylabel','RMSE');

% All
f4 = copyobj(f,0);
lgd = legend(mat2cell('a':char('a'+curves-1), 1, ones(curves, 1)));
stackplots(f4,m,n,'xlabel','Iterations','ylabel','RMSE');