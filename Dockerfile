# Build from the MATLAB base image
FROM matlab:r2022a

USER vkoren

# Copy your script/function to be executed.
WORKDIR /workdir 

# Start MATLAB in batch mode and execute your script/function.
#CMD ["-batch","script1"]

# allows interactive matlab
CMD ["-nojvm", "-r", "script_run"] 