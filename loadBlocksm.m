open_system('SIMULINK_RSED_MODEL.slx');
% this is the standard simulink path for user defined matlab functions
libraryBlockPath = 'simulink/User-Defined Functions/MATLAB Function';

func_list = dir("functions\*.m");

for f = 1:length(func_list)
    func_name = func_list(f).name;
    
    newBlockPath = strcat('SIMULINK_RSED_MODEL/', erase(func_name, ".m"))
    % Add a MATLAB Function to the model
    add_block(libraryBlockPath, newBlockPath);
    % In memory, open models and their parts are represented by a hierarchy of
    % objects. The root object is slroot. This line of the script returns the
    % object that represents the new MATLAB Function block:
    blockHandle = find(slroot, '-isa', 'Stateflow.EMChart', 'Path', newBlockPath);
    % The Script property of the object contains the contents of the block,
    % represented as a character vector. This line of the script loads the
    % contents of the file myAdd.m into the Script property:
    blockHandle.Script = fileread(strcat('functions/', func_name));
    % Alternatively, you can specify the code directly in a character vector.
    % For example: 
    % blockHandle.Script = 'function c = fcn (a, b)';
end


