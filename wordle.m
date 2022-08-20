% clear all
clc;

% get words from wordData.txt
words = [];
fid = fopen("wordData.txt");

tline = fgetl(fid);
while ischar(tline)
    words = [words string(tline)];
    tline = fgetl(fid);
end
fclose(fid);

% check if a word is valid
inputWord = input("Enter a 5-letter word: ", 's');

if(ismember(inputWord, words))
    disp('word is valid');
else
    disp('word is not valid');
end


