cd ../

% Load data
clusters = table2cell(readtable('Pangenome_calculation/Functional_analysis/modifiedOutput.txt', ...
    'ReadVariableNames', false, 'Delimiter', '\t'));
proteome = table2cell(readtable('Pangenome_calculation/Functional_analysis/proteome_modified.txt', ...
    'ReadVariableNames', false, 'Delimiter', '\t'));

% Replace names
for n = 1:length(proteome)
    name = strcat(proteome{n,1}, '...');
    location = strfind(clusters(:,3), name);
    location(cellfun(@isempty, location)) = {0};
    proteome{n,1} = clusters{logical(cell2mat(location)),1};
end

% Write file
proteome = cell2table(proteome);
writetable(proteome, 'Pangenome_calculation/Functional_analysis/proteome_modified_renamed.txt', ...
    'WriteVariableNames', false, 'Delimiter', '\t');

% Exit
quit
