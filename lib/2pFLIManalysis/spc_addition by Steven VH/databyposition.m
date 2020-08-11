function newmat = databyposition(data,position)
% takes two 1xN vectors where the first contains data and the second
% contains the dataset that they correspond to.
%
% The output newmat is a Kx1 cell matrix where K is the largest dataset index.
% each entry in newmat is a vector with data from that dataset.  

% Datasets that don't have fewer members than the number of columns of
% newmat will have their rows padded by NaN

% Honi Sanders 11/2012

data=squeeze(data);
if size(data,1) > 1
	assert(size(data,2)==1,'databyposition() requires 2 1-d vectors of the same length');
	data=data';
end

position=squeeze(position);
if size(position,1) > 1
	assert(size(position,2)==1,'databyposition() requires 2 1-d vectors of the same length');
	position=position';
end

%assert(length(position)==length(data),'databyposition() requires 2 1-d vectors of the same length');


N = min(length(position),length(data));
position = position(1:N);
data = data(1:N);
K = max(position);

newcell = cell(K,1);
for j = 1:K
	newcell{j} = j;
end
for i = 1:N
	j = position(i);
	newcell{j} = [newcell{j} data(i)];
end

L = 0;	% length of longest dataset
for j = 1:K
	L = max(L,length(newcell{j}));
end

newmat = nan(K,L);
for j = 1:K
	newmat(j,1:length(newcell{j})) = newcell{j};
end
	

