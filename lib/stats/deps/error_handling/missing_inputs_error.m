% 'missing_inputs_error' Exception
%   Error raised when a function does not recieve all inputs
%
% INPUTS
% ------
% <nArgsGiven>, number: The number of arguments the function recieved
% <nArgsExpected>, number: The number of arguments that were expected
%
function [ME] = missing_inputs_error(nArgsGiven, nArgsExpected)
    ME = MException('MATLAB:MissingInputs', 'Missing some inputs: %d inputs were given but %d were expected', nArgsGiven, nArgsExpected);
end