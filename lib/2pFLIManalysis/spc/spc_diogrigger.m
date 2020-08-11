function spc_diogrigger;

putvalue(state.spc.init.spc_line, 1);
putvalue(state.spc.init.spc_line, 0);
        
putvalue(state.init.triggerLine, 1);			% Places an 'on' signal on the line initially
putvalue(state.init.triggerLine, 0); 			% Digital Trigger: Places a go signal (1 to 0 transition; FallingEdge) to 
												% the line to trigger the ao1, ao2, & ai.
