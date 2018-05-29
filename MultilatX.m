%Multilat5S
%Finds the unknown location of a signal emitter based on known locations of
%N sensors, and the known difference in time between each sensor receiving
%the signal.

%Reset Command window
clc

%%{
%Hard set inputs
%Reception times relative to each other
t1=0.005394641;
t2=0.004866213;
t3=0;
t4=0.001619442;
t5=0.002170021;
t6=0.000618338;
t7=0.008088502;
t8=0.001729873;
%t9=0;
%Sound velocity
v=343;
%Sensor positions relative to each other
p1=[-1  0  0];
p2=[ 0 -1  0];
p3=[ 1  0  1];
p4=[ 0  1  0];
p5=[ 0  0  1];
p6=[ 1  1 -1];
p7=[-1 -1 -1];
p8=[ 1 -1  1];
%p9=[-1  1  2];
%Misc vars init
cumSumX = 0;
cumSumY = 0;
cumSumZ = 0;
iterations = 0;
numMics = 6;
numCombinations = factorial(numMics)/(factorial(4)*factorial(numMics-4));
combinationsMatrix = combinator(numMics,4,'c'); % Combinations without repetition (borrowed code)
%}

%{
%Prompt user for inputs
numMics=input('How many microphones are there? \n');
t1=input('At what time (in seconds) did Sensor 1 register a sound? \n');
t2=input('At what time (in seconds) did Sensor 2 register a sound? \n');
t3=input('At what time (in seconds) did Sensor 3 register a sound? \n');
t4=input('At what time (in seconds) did Sensor 4 register a sound? \n');
t5=input('At what time (in seconds) did Sensor 5 register a sound? \n');
t6=input('At what time (in seconds) did Sensor 6 register a sound? \n');
t7=input('At what time (in seconds) did Sensor 7 register a sound? \n');
t8=input('At what time (in seconds) did Sensor 8 register a sound? \n');
t9=input('At what time (in seconds) did Sensor 9 register a sound? \n');
v=input('What is the current speed of sound? \n');
p1=input('What are the coordinates of microphone 1? \n');
p2=input('What are the coordinates of microphone 2? \n');
p3=input('What are the coordinates of microphone 3? \n');
p4=input('What are the coordinates of microphone 4? \n');
p5=input('What are the coordinates of microphone 5? \n');
p6=input('What are the coordinates of microphone 6? \n');
p7=input('What are the coordinates of microphone 7? \n');
p8=input('What are the coordinates of microphone 8? \n');
p9=input('What are the coordinates of microphone 9? \n');
%}

%Collect emitter location estimates for each combination of 4 sensors
for i=1:numCombinations
    f = cell(4, 1);
    g = cell(4, 1);
    %Concatenate t# and p# to prep for Solver5S
    for j=1:4
        f{j} = strcat('t', num2str(combinationsMatrix(i,j)));
        g{j} = strcat('p', num2str(combinationsMatrix(i,j)));
    end
    %Actually do some solving now
    [positionX,positionY,positionZ] = Solver5S(eval(f{1}),eval(f{2}),eval(f{3}),eval(f{4}),v,eval(g{1}),eval(g{2}),eval(g{3}),eval(g{4}));
    cumSumX = cumSumX+positionX;
    cumSumY = cumSumY+positionY;
    cumSumZ = cumSumZ+positionZ;
    iterations = iterations+1;
end
%Calculate average of positions
avgPosX = cumSumX/iterations;
avgPosY = cumSumY/iterations;
avgPosZ = cumSumZ/iterations;
%Display answer
fprintf("Emitter is located at (%4.2f,%4.2f,%4.2f)",avgPosX,avgPosY,avgPosZ)
