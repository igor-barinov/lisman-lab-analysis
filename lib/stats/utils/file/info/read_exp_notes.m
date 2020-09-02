function [foundDNAType, nSolutionsFound, dnaType, solutions] = read_exp_notes(notes)
    dnaType = '';
    solutions = {};
    
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Find first pattern for the dna type
    lowerNotes = lower(notes);
    
    startPattern = 'no';
    startPatternLen = 9;
    searchStart = strfind(lowerNotes, startPattern);
    
    if isempty(searchStart)
        foundDNAType = false;
    else
        %% Find second pattern for the dna type
        dnaBegin = searchStart(1) + startPatternLen;
        
        endPattern1 = 'cells are';
        endPattern2 = 'confluency';
        searchEnd1 = strfind(lowerNotes, endPattern1);
        searchEnd2 = strfind(lowerNotes, endPattern2);
        
        if ~isempty(searchEnd1)
            dnaEnd = searchEnd1(1) - 1;
        elseif ~isempty(searchEnd2)
            dnaEnd = searchEnd2(1) - 5;
        else
            dnaEnd = -1;
        end
        
        %% Extract the dna type
        if dnaEnd > 0       
            dnaType = strtrim(notes(dnaBegin:dnaEnd));
            foundDNAType = true;
        else
            foundDNAType = false;
        end
    end
    
    
    %% Find first patterns for solutions
    nSolutionsFound = 0;
    
    baseSolPattern = 'start with';
    baseSolPatternLen = 11;
    solPattern = 'after';
    solPatternLen = 5;
    
    searchStart = strfind(lowerNotes, baseSolPattern);
    searchSolutions = strfind(lowerNotes, solPattern);
    
    if ~isempty(searchSolutions)
        if ~isempty(searchStart)
            %% Get the baseline solution
            baseSolBegin = searchStart(1) + baseSolPatternLen;
            baseSolEnd = searchSolutions(1) - 1;
            
            baselineSol = strtrim(notes(baseSolBegin:baseSolEnd));
            solutions = {baselineSol, 1};
            
            nSolutionsFound = nSolutionsFound + 1;
        end
        
        %% Try finding remaining solution info
        nPossibleSol = numel(searchSolutions);
        timingPattern = 'img';
        timingPatternLen = 3;
        
        for i = 1:nPossibleSol
            solSearch = searchSolutions(i) + solPatternLen;
            
            %% Find timing pattern
            searchStart = strfind(lowerNotes, timingPattern);
            searchStart = searchStart(searchStart > solSearch);
            if isempty(searchStart)
                continue;
            end
            
            %% Extract timing info
            timingBegin = searchStart(1) + timingPatternLen;
            timingEnd = timingBegin + 1;
            timingStr = strtrim(notes(timingBegin:timingEnd));
            timing = str2double(timingStr);
            if isnan(timing)
                continue;
            end
            
            %% Find first solution pattern
            solPattern2 = 'start';
            solPattern2Len = 5;
            searchStart = strfind(lowerNotes, solPattern2);
            searchStart = searchStart(searchStart > timingEnd);
            if isempty(searchStart)
                continue;
            end
            
            %% Get second solution pattern
            if i == nPossibleSol
                continue;
            end
            searchEnd = searchSolutions(i+1);
            
            %% Extract solution info
            solBegin = searchStart(1) + solPattern2Len;
            solEnd = searchEnd - 1;
            solution = strtrim(notes(solBegin:solEnd));
            
            solutions = [solutions; {solution, timing}];
            nSolutionsFound = nSolutionsFound + 1;
        end
    end
end
