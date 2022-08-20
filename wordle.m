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

% game start

keepPlaying = true;

% innitial answer
anwser = wordData(randi(length(wordData)));

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
end

disp('Congratulation! The word is: ' + anwser);
