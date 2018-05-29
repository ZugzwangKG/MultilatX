function [positionX,positionY,positionZ] = Solver5S(t1,t2,t3,t4,v,p1,p2,p3,p4)

%Finds which sensor is closest to the emitter
%Then calculates the distance between the emitter and that sensor
%Then finds the coordinates of the emitter

%a=S1, b=S2, c=S3, d=S4
syms a b c d closestSensorNumber

%Which sensor is closest?
closestSensorTime = t1;
closestSensorNumber = a;
if t2<closestSensorTime
    closestSensorTime = t2;
    closestSensorNumber = b;
end
if t3<closestSensorTime
    closestSensorTime = t3;
    closestSensorNumber = c;
end
if t4<closestSensorTime
    closestSensorTime = t4;
    closestSensorNumber = d;
end

%Subtract value of closestSensor from all 4 sensors to format data
t1 = t1-closestSensorTime;
t2 = t2-closestSensorTime;
t3 = t3-closestSensorTime;
t4 = t4-closestSensorTime;

%Set a,b,c,d to be in terms of closest sensor
a = closestSensorNumber + (v*t1);
b = closestSensorNumber + (v*t2);
c = closestSensorNumber + (v*t3);
d = closestSensorNumber + (v*t4);

%Format Given Matrices
matrix1 = [a^2-p1(1)^2-p1(2)^2-p1(3)^2  ;
           b^2-p2(1)^2-p2(2)^2-p2(3)^2  ;
           c^2-p3(1)^2-p3(2)^2-p3(3)^2  ;
           d^2-p4(1)^2-p4(2)^2-p4(3)^2
          ];
matrix2 = [1 -2*p1(1) -2*p1(2) -2*p1(3)  ;
           1 -2*p2(1) -2*p2(2) -2*p2(3)  ;  
           1 -2*p3(1) -2*p3(2) -2*p3(3)  ;
           1 -2*p4(1) -2*p4(2) -2*p4(3)
          ];
%Inverse of matrix 2
matrixInv = inv(matrix2);   %This matches what we had before
%Matrix multiplication ---> x=A^(-1)B
matrixProduct = matrixInv*matrix1;

%Row Sums
first = sum(matrixProduct(1,:));    %Correct
x = sum(matrixProduct(2,:));        %Correct
y = sum(matrixProduct(3,:));        %Correct
z = sum(matrixProduct(4,:));        %Correct

%Squares of Row Sums
x2 = x*x;    %Correct
y2 = y*y;    %Correct
z2 = z*z;    %Correct

%%{
%Solve Eqn
eqn = (x2+y2+z2)-(first);  %Updated for universality
solution = solve(eqn,closestSensorNumber, 'MaxDegree', 5);   %Solve for closestSensorNumber
%}

%Evaluate Eqn
closestSensorDistance = eval(solution);    %Returns 2 possible values of hyperbola
closestSensorNumber = max(closestSensorDistance);  %Gives the distance between emitter and closest Sensor

%Update a,b,c,d to be distances, not times
a = closestSensorNumber + (v*t1);
b = closestSensorNumber + (v*t2);
c = closestSensorNumber + (v*t3);
d = closestSensorNumber + (v*t4);

%Calculate Emitter Position
%Calculate X-coordinate
positionX = eval(x);
%Calculate Y-coordinate
positionY = eval(y);
%Calculate Z-coordinate
positionZ = eval(z);
end