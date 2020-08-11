function colorim = h_merge2color(greenim,redim,filter_on,climitg,climitr, fig_on)

greenim = double(greenim);
redim = double(redim);

if ~(exist('filter_on'))==1
    filter_on = 1;
elseif isempty(filter_on)
    filter_on = 1;
end

if ~(exist('fig_on'))==1
    fig_on = 0;
elseif isempty(fig_on)
    fig_on = 0;
end

if ~(exist('climitg')==1)
    climitg = [];
end

if ~(exist('climitr')==1)
    climitr = [];
end

if isempty(climitg)
    temp2 = sort(greenim(:));
    climitg = [temp2(round(0.05*length(temp2))),temp2(round(0.99*length(temp2)))];
end

if isempty(climitr)
    temp2 = sort(redim(:));
    climitr = [temp2(round(0.05*length(temp2))),temp2(round(0.98*length(temp2)))];
end


greenim = (greenim - climitg(1))/(climitg(2) - climitg(1));
redim = (redim - climitr(1))/(climitr(2) - climitr(1));

if filter_on
    f = ones(3)/9;
    greenim = filter2(f, greenim);
    redim = filter2(f, redim);
end

greenim(greenim > 1) = 1;
greenim(greenim < 0) = 0;

redim (redim >=1) = 1;
redim (redim < 0) = 0;

colorim = zeros(size(greenim,1), size(greenim,2), 3);
colorim(:, :, 1) = redim;
colorim(:, :, 2) = greenim;

if fig_on
    fig = figure;
    image(colorim);
    set(fig,'Tag','Analysis');
    set(gca, 'XTickLabel', '', 'YTickLabel', '');
end