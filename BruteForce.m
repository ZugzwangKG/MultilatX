clc
close all

%Prepare guess array
guesses = zeros(800,3);
guessNumber = 1;  %Row 1
percent = 0.01;

%Receiver Positions & times
p1=[-1  0  0];
p2=[ 0 -1  0];
p3=[ 1  0  1];
p4=[ 0  1  0];
p5=[ 0  0  1];
t1=0.0031;
t2=0.0056;
t3=0.0019;
t4=0;
t5=0.0022;

fprintf("Start \n")

for x = -800:1:800
    for y = -800:1:800
        if x >= y
            continue
        end
        for z = 0:1:200
            if z<=(2*x)
                continue
            end
            %Calculate the distance of the two receivers with the lowest
            %tdoa
            distance4 = sqrt((x-p4(1))^2+(y-p4(2))^2+(z-p4(3))^2);
            distance3 = sqrt((x-p3(1))^2+(y-p3(2))^2+(z-p3(3))^2);
            if (distance4 >= distance3)   %If not new biggest, continue
                continue
            end
            %Calculate the distance of the receiver with the next lowest
            %tdoa
            distance5 = sqrt((x-p5(1))^2+(y-p5(2))^2+(z-p5(3))^2);
            if (distance3 >= distance5)   %If not new biggest, continue
                continue
            end
            %Calculate the distance of the receiver with the next lowest
            %tdoa
            distance1 = sqrt((x-p1(1))^2+(y-p1(2))^2+(z-p1(3))^2);
            if (distance5 >= distance1)   %If not new biggest, continue
                continue
            end
            %Calculate the distance of the receiver with the next lowest
            %tdoa
            distance2 = sqrt((x-p2(1))^2+(y-p2(2))^2+(z-p2(3))^2);
            if (distance1 >= distance2)   %If not new biggest, continue
                continue
            end
            
            %If you get to here, then you have found a valid tdoa ordering
            %relationship.  Let's test some more.
            tdoa4 = (distance4/343)-(distance4/343);
            tdoa3 = (distance3/343)-(distance4/343);
            tdoa5 = (distance5/343)-(distance4/343);
            tdoa1 = (distance1/343)-(distance4/343);
            tdoa2 = (distance2/343)-(distance4/343);
            
            %If the calculated value of any tdoa deviates more than 5% of 
            %the ideal, then this is not a possible answer
            if (tdoa1 >= (t1+(percent*t1))) || (tdoa1 <= (t1-(percent*t1)))
                continue
            end
            if (tdoa2 >= (t2+(percent*t2))) || (tdoa2 <= (t2-(percent*t2)))
                continue
            end
            if (tdoa3 >= (t3+(percent*t3))) || (tdoa3 <= (t3-(percent*t3)))
                continue
            end
            if (tdoa5 >= (t5+(percent*t5))) || (tdoa5 <= (t5-(percent*t5)))
                continue
            end
%%{
            %If you get here, then the set is probably an accurate guess,
            %so let's store this data.
            guesses(guessNumber,1) = x;
            guesses(guessNumber,2) = y;
            guesses(guessNumber,3) = z;
            guessNumber = guessNumber + 1;  %Row incrementer
%}
        end    
    end    
end
guesses = guesses(any(guesses,2),:)    %Shorten the array by removing null rows

%figure
%plot(guesses)

guessNumber = guessNumber-1;
%Separate data into x,y,z components
componentX = guesses(:,1);
componentY = guesses(:,2);
componentZ = guesses(:,3);

guesses_ave=mean(guesses,1);                  % mean; line of best fit will pass through this point  
dGuesses=bsxfun(@minus,guesses,guesses_ave);  % residuals
C=(dGuesses'*dGuesses)/(guessNumber-1);       % variance-covariance matrix of X
[R,D]=svd(C,0)                                % singular value decomposition of C; C=R*D*R'

scatter3(componentX,componentY,componentZ);

%%{
figure
hold on
plot(componentX);
%plot(componentY);
plot(componentZ);
grid on
hold off
%}

fprintf("\n guessNumber = %f",guessNumber)
fprintf("\n End")
