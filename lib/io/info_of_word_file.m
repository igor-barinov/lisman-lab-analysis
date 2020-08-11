function [notes, dnaType, solutions] = info_of_word_file(filepath)
    dnaType = '';
    solutions = {};
    
    % Load the document
    wordClient = actxserver('Word.Application');
    wordDoc = wordClient.Documents.Open(filepath);
    notes = wordDoc.Content.Text;
    wordDoc.Close();
    wordClient.Quit();
    uniformNotes = lower(notes);    
    
    % Find the DNA type
    % Format: ... NOMMDDYYX [dnaType] cells are ...
    startPattern = 'no';
    endPattern = 'cells are';
    
    startIdx = strfind(uniformNotes, startPattern);
    if ~isempty(startIdx)
        endIdx = strfind(uniformNotes, endPattern);
        endIdx = endIdx(endIdx > startIdx(1));
        if ~isempty(endIdx)
            dnaIdx = startIdx(1) + length('nommddyyx');
            dnaType = notes(dnaIdx : endIdx(1)-1);
        end
    end
    
    % Find baseline solutions
    % Format: ... Start with [baseSolution] (...
    startPattern = 'start with';
    endPattern = '(';
    
    startIdx = strfind(uniformNotes, startPattern);
    if ~isempty(startIdx)
        endIdx = strfind(uniformNotes, endPattern);
        endIdx = endIdx(endIdx > startIdx(1));
        if ~isempty(endIdx)
            solutionIdx = startIdx(1) + length(startPattern);
            solutionName = strtrim(notes(solutionIdx : endIdx-1));
            solutions = [solutions; {solutionName, 1}];
        end
    end
    
    % Find remaining solutions
    % Format: ... After img[timing] start [solution]. ...
    timingStartPtrn = 'after img';
    timingEndPtrn = 'start';
    nameEndPtrn = '.';
    
    % Find first pattern: '... After img[timing] ...'
    timingStartIndices = strfind(uniformNotes, timingStartPtrn);
    if ~isempty(timingStartIndices)
        % Find second pattern: ' ... start ...'
        timingEndIndices = strfind(uniformNotes, timingEndPtrn);
        timingEndIndices = timingEndIndices(timingEndIndices > timingStartIndices(1));
        
        if ~isempty(timingEndIndices)
            % Find third pattern: ' ... [solution]. ...'
            nameEndIndices = strfind(uniformNotes, nameEndPtrn);
            nameEndIndices = nameEndIndices(nameEndIndices > timingEndIndices(1));
            
            if ~isempty(nameEndIndices)
                solutionCount = min([numel(timingStartIndices), numel(timingEndIndices), numel(nameEndIndices)]);
                
                if solutionCount > 0
                    for i = 1:solutionCount
                        timingIdx = timingStartIndices(i) + length(timingStartPtrn);
                        nameIdx = timingEndIndices(i) + length(timingEndPtrn);
                        solTiming = str2double(notes(timingIdx : timingEndIndices(i)-1));
                        solName = strtrim(notes(nameIdx : nameEndIndices(i)-1));
                        
                        if ~isempty(solName) && ~isnan(solTiming)
                            solutions = [solutions; {solName, solTiming}];
                        end
                    end
                end
            end
        end 
    end
end