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

function stackplots(fig,m,n,varargin)
%% Stack given subplots in mxn format with overlapping axes
% INPUTS:
%	fig -- figure with mxn subplots
%   m -- number of rows
%   n -- number of columns
% PARAMETERS (key-value pairs):
%   xlabel -- global x axis label
%   ylabel -- global y axis label

p = inputParser;

p.addParameter('xlabel', '', @(x) true);
p.addParameter('ylabel', '', @(x) true);

p.parse(varargin{:});
args = p.Results;

set(0, 'currentfigure', fig);
splot = zeros(m*n,1);
for i = 1:m*n
    splot(i) = subplot(m,n,i);
end
lgd = findobj(gcf,'Tag','legend');

if lgd ~= 0
    lgdslice = 0.15;    % save space for the legend
else
    lgdslice = 0;
end

pos=get(splot,'position');

bottom=pos{end}(2);
top=pos{1}(2)+pos{1}(4);
yplotspace=top-bottom;

left=pos{1}(1);
right=pos{n}(1)+pos{n}(3);
xplotspace=right-left-lgdslice;

% All plots are equal in size
for i = 1:length(splot)
    pos{i}(3)=xplotspace/n;
    pos{i}(4)=yplotspace/m;
end

% Reposition the y coordinate in yplotspace/m increments
for i = m*n-n:-1:1
    pos{i}(2) = pos{i+n}(2)+yplotspace/m;
end

% Reposition the x coordinate in xplotspace/n increments
for i = 0:m-1
    for j = 2:n
        pos{i*n+j}(1) = pos{i*n+j-1}(1)+xplotspace/n;
    end
end

% Walk all subplots
for i = 1:length(splot)
    set(splot(i),'position',pos{i}); % Set new subplot positions
    set(splot(i),'TickLabelInterpreter','latex'); % LaTex interp
end

%% Avoid overlapping
% Cancel ticklabels for all but bottom and side plots
for i=1:m*n-n
    set(splot(i),'xticklabels',[]);
end
for i=0:m-1
    for j=2:n-1
        set(splot(i*n+j),'yticklabels',[]);
    end
end
% Move yticklabels on the right-hand side
for i=0:m-1
    set(splot(i*n+n),'yaxislocation','right');
end
% Remove last ytick from all but top plots
for i=1:m-1
    % Left-hand side
    labels = get(splot(i*n+1),'YTickLabels');
    labels{end}='';
    set(splot(i*n+1),'YTickLabels',labels);
    % Right-hand side
    labels = get(splot(i*n+n),'YTickLabels');
    labels{end}='';
    set(splot(i*n+n),'YTickLabels',labels);
end
% Remove last xtick from all but the rightmost bottom plot
for i=1:n-1
    labels = get(splot((m-1)*n+i),'XTickLabels');
    labels{end}='';
    set(splot((m-1)*n+i),'XTickLabels',labels);
end

%% Text placement
% Legend
if lgdslice > 0
    lgd.FontSize = 9;
    lgd.Position=[right 0.5 0 0];
end

% Labels
if ~isempty(args.xlabel) || ~isempty(args.ylabel)
    h = axes('Position',[0 0 1 1],'Visible','off'); % Add figure axis
    set(gcf,'CurrentAxes',h)
end
if args.ylabel
    text(.08,.45,args.ylabel,...
    'Interpreter', 'latex',...
    'VerticalAlignment','bottom',...
    'HorizontalAlignment','left', 'Rotation', 90, 'FontSize',12)
end
if args.xlabel
    text(.45,0,args.xlabel,...
    'Interpreter', 'latex',...
    'VerticalAlignment','bottom',...
    'HorizontalAlignment','center', 'FontSize',12)
end
