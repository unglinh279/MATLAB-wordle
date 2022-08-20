% clear all
clc;

% get words from wordData.txt
wordData = [];
fid = fopen("wordData.txt");

tline = fgetl(fid);
while ischar(tline)
    wordData = [wordData string(tline)];
    tline = fgetl(fid);
end
fclose(fid);

% innitial answer
anwser = wordData(randi(length(wordData)));

fprintf("Notes: \n 0: Wrong letter \n 1: Correct letter \n 2: Correct letter but wrong position \n");

% start guessing
disp(anwser);
while true
    guess = "";
    while ~(ismember(guess, wordData))
        guess = input('Enter a 5-letter word: ', "s");
        guess = string(guess);
    end

    if strcmp(guess, anwser)
        break;
    end

    output = zeros(1,5);
    ansCheck = zeros(1, 5);

    for i = 1:5
        if extract(anwser, i) == extract(guess, i)
            output(i) = 1;
            ansCheck(i) = 1;
        end
    end

    for i = 1:5
        if output(i) ~= 1
            for j = 1:5
                if ~ansCheck(j) && extract(guess, i) == extract(anwser, j)
                    output(i) = 2;
                    ansCheck(j) = 1;
                end
            end
        end
    end

    disp(output);
end

disp('Congratulation! The word is: ' + anwser);
