function [ A, B ] = csv_to_value_matrix(data,index)

% convert UN Comtrade commodity data (.csv format) to matrix

% INPUT: 
% data - UN comtrade data: import raw .csv as a table <-- important!
% index - list of UN country codes selected (i.e., 156 = China...)

% OUTPUT:
% A - weighted adjacency matrix of trade (measured in US$)
% B - adjacency matrix of trade

min_year = min(data.Year); % find start year
max_year = max(data.Year); % find end year
A = zeros(length(index), length(index), numel(unique(data.Year)));
B = zeros(length(index), length(index), numel(unique(data.Year)));

for i = 1:numel(unique(data.Year))
    y = data.Year==(min_year-1)+i;                          % filter data by year
    % Use the ismember function to get the mapping between vertex ids and
    % their consecutive index mappings:
    [~,from] = ismember(data.ReporterCode(y), index);       % exporter index
    [~,to] = ismember(data.PartnerCode(y), index);          % impoerter index
    Adj = zeros(length(index), length(index));
    % Use sub2ind to populate adjacency matrix:
    linear_ind = sub2ind(size(Adj), from, to);
    Adj(linear_ind) = data.Value(y);                        % add value of trade
    A(:,:,i) = Adj;
    B(:,:,i) = Adj > 0;
end

end
