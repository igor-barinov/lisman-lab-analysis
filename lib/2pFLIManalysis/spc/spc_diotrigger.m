function spc_diotrigger;

global state
global gh

% diotrigger.m****
% Function that ouputs a single 1,0 to the dio device, acting as the falling edge trigger for the DAQ devices.
%
% This function is used to "start" the DAQ session. 
%
% This function also opens the shutter prior to acquisition.
%
% Written By: Thomas Pologruto
% Cold Spring Harbor Labs
% February 7, 2001

state.internal.dioTriggerTime = clock;


%Ryohei 9/17/2 For FLIM

% Acquisition Board Trigger
putvalue(state.init.triggerLine, 1);			% Places an 'on' signal on the line initially
putvalue(state.init.triggerLine, 0); 			% Digital Trigger: Places a go signal (1 to 0 transition; FallingEdge) to 
												% the line to trigger the ao1, ao2, & ai.

