function varargout = gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);

function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% INITIALIZE THE GAME
function startBtn_Callback(hObject, eventdata, handles)
global display guessNum wordData answer;

% clear all
clc;

set(handles.endTxt, 'visible', 'off');
set(handles.ansTxt, 'visible', 'off');
set(handles.guessInput, 'visible', 'on');
set(handles.startBtn, 'visible', 'off');

guessNum = 1;
display = [handles.dis11 handles.dis12 handles.dis13 handles.dis14 handles.dis15; ...
           handles.dis21 handles.dis22 handles.dis23 handles.dis24 handles.dis25; ...
           handles.dis31 handles.dis32 handles.dis33 handles.dis34 handles.dis35; ...
           handles.dis41 handles.dis42 handles.dis43 handles.dis44 handles.dis45; ...
           handles.dis51 handles.dis52 handles.dis53 handles.dis54 handles.dis55];

for i = 1:5
    for j = 1:5
        set(display(i, j), 'String', '');
        set(display(i, j), 'BackgroundColor', [0.31, 0.31, 0.31]);
    end
end

% get words from wordData.txt
wordData = [];
fid = fopen("wordData.txt");

tline = fgetl(fid);
while ischar(tline)
    wordData = [wordData string(tline)];
    tline = fgetl(fid);
end
fclose(fid);

% avoid same random numbers after startup
rng('shuffle');

% innitial answer
answer = wordData(randi(length(wordData)));


% every input
function guessInput_Callback(hObject, eventdata, handles)
global display guessNum wordData answer

% START GUESSING
guess = get(hObject, 'String');

if length(guess) ~= 5
    msgbox("Please enter a 5 letter word")
elseif ~ismember(guess, wordData)
    msgbox("Word is not valid")
else
    output = zeros(1,5);
    ansCheck = zeros(1, 5);
    
    for i = 1:5
        if extract(answer, i) == extract(guess, i)
            output(i) = 1;
            ansCheck(i) = 1;
        end
    end
    
    for i = 1:5
        if output(i) ~= 1
            for j = 1:5
                if ~ansCheck(j) && extract(guess, i) == extract(answer, j)
                    output(i) = 2;
                    ansCheck(j) = 1;
                end
            end
        end
    end
    
    for i = 1:5
        set(display(guessNum, i), 'String', upper(extract(guess, i)));
        if output(i) == 1
            set(display(guessNum, i), 'BackgroundColor', [0.094, 0.647, 0.22]);
        elseif output(i) == 2
            set(display(guessNum, i), 'BackgroundColor', [0.839, 0.749, 0.314]);
        else
            set(display(guessNum, i), 'BackgroundColor', [0.655, 0.655, 0.655]);
        end
    end
    
    guessNum = guessNum + 1;

    if strcmp(guess, answer)
        gameEnd(1, handles);
    elseif guessNum > 5
        gameEnd(0, handles)
    end
end

set(handles.guessInput, 'String', '');

function gameEnd(state, handles)
global answer;

set(handles.endTxt, 'visible', 'on');
set(handles.ansTxt, 'visible', 'on');
set(handles.guessInput, 'visible', 'off');

set(handles.ansTxt, 'String', "THE WORD IS: " + upper(answer));

if(state == 1)
    set(handles.endTxt, 'ForegroundColor', [0.094, 0.647, 0.22]);
    set(handles.ansTxt, 'ForegroundColor', [0.094, 0.647, 0.22]);
    set(handles.endTxt, 'String', "YOU WON!");
else
    set(handles.endTxt, 'ForegroundColor', [1.0, 0.0, 0.0]);
    set(handles.ansTxt, 'ForegroundColor', [1.0, 0.0, 0.0]);
    set(handles.endTxt, 'String', "YOU LOSE!");
end

set(handles.startBtn, 'visible', 'on');
set(handles.startBtn, 'String', "PLAY AGAIN");


% --- Executes during object creation, after setting all properties.
function guessInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
