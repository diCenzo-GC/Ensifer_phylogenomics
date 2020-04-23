%% Import data

% Load the tables
geneFile = table2cell(readtable('Horizontal_transfer/geneHeaders_genes.txt', ...
    'Delimiter', '\t'));
proteinFile = table2cell(readtable('Horizontal_transfer/geneHeaders_proteins.txt', ...
    'Delimiter', '\t'));

% Sort the tables
geneFile = sortrows(geneFile, 1);
proteinFile = sortrows(proteinFile, 1);

%% Link the data

% Run the script
output = cell(length(proteinFile), 4);
x = 0;
for n = 1:length(proteinFile)
    test = 0;
    x = x + 1;
    while test == 0
        if strmatch(proteinFile{n,1}, geneFile{x,1}, 'exact')
            output{n,1} = geneFile{x,1};
            output{n,2} = geneFile{x,2};
            output{n,3} = proteinFile{n,1};
            output{n,4} = proteinFile{n,2};
            test = 1;
        else
            x = x + 1;
        end
    end
end

%% Get name for 99% hits

% Load the table
hitFile = table2cell(readtable('Horizontal_transfer/blast_output_99_99.txt',...
    'Delimiter', '\t'));

% Get just the unique query sequences
hits = unique(hitFile(:,1));
hits = sortrows(hits, 1);

% Sort linked file
output = sortrows(output, 2);

% Switch names
output2 = {};
x = 0;
for n = 1:length(hits)
    pos = strmatch(hits{n}, output(:,2));
    if ~isempty(pos)
        output2{end+1} = output{pos,4};
    end
end
output2 = transpose(output2);

% Export as table
exportTable = cell2table(output2);
writetable(exportTable, 'Horizontal_transfer/genes_99.txt', 'Delimiter', '\t',...
    'WriteVariableNames', false);

%% Get name for 95% hits

% Load the table
hitFile = table2cell(readtable('Horizontal_transfer/blast_output_95_95.txt',...
    'Delimiter', '\t'));

% Get just the unique query sequences
hits = unique(hitFile(:,1));
hits = sortrows(hits, 1);

% Sort linked file
output = sortrows(output, 2);

% Switch names
output2 = {};
x = 0;
for n = 1:length(hits)
    pos = strmatch(hits{n}, output(:,2));
    if ~isempty(pos)
        output2{end+1} = output{pos,4};
    end
end
output2 = transpose(output2);

% Export as table
exportTable = cell2table(output2);
writetable(exportTable, 'Horizontal_transfer/genes_95.txt', 'Delimiter', '\t',...
    'WriteVariableNames', false);

%% Get name for 99% hits

% Load the table
hitFile = table2cell(readtable('Horizontal_transfer/blast_output_98_98.txt',...
    'Delimiter', '\t'));

% Get just the unique query sequences
hits = unique(hitFile(:,1));
hits = sortrows(hits, 1);

% Sort linked file
output = sortrows(output, 2);

% Switch names
output2 = {};
x = 0;
for n = 1:length(hits)
    pos = strmatch(hits{n}, output(:,2));
    if ~isempty(pos)
        output2{end+1} = output{pos,4};
    end
end
output2 = transpose(output2);

% Export as table
exportTable = cell2table(output2);
writetable(exportTable, 'Horizontal_transfer/genes_98.txt', 'Delimiter', '\t',...
    'WriteVariableNames', false);

%% Exit

quit
