function varargout = LFM(varargin)
% LFM MATLAB code for LFM.fig
%      LFM, by itself, creates a new LFM or raises the existing
%      singleton*.
%
%      H = LFM returns the handle to a new LFM or the handle to
%      the existing singleton*.
%
%      LFM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LFM.M with the given input arguments.
%
%      LFM('Property','Value',...) creates a new LFM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LFM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LFM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LFM

% Last Modified by GUIDE v2.5 26-Dec-2018 11:54:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LFM_OpeningFcn, ...
                   'gui_OutputFcn',  @LFM_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before LFM is made visible.
function LFM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LFM (see VARARGIN)

% Choose default command line output for LFM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LFM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LFM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Band_Callback(hObject, eventdata, handles)
% hObject    handle to Band (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Band as text
%        str2double(get(hObject,'String')) returns contents of Band as a double


% --- Executes during object creation, after setting all properties.
function Band_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Band (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulseWidth_Callback(hObject, eventdata, handles)
% hObject    handle to PulseWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PulseWidth as text
%        str2double(get(hObject,'String')) returns contents of PulseWidth as a double


% --- Executes during object creation, after setting all properties.
function PulseWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulseWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Initialization.
function Initialization_Callback(hObject, eventdata, handles)
% hObject    handle to Initialization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Band, 'string', 'Please Input a Value');
set(handles.PulseWidth, 'string', 'Please Input a Value');

% --- Executes during object creation, after setting all properties.
function Initialization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Initialization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Band = str2double(get(handles.Band, 'string'));
Pulse_width = str2double(get(handles.PulseWidth, 'string'));
% 按照Nyquist采样定理 设置采样率为两倍带宽
Fs = 2 * Band;
N_Points = Pulse_width*Fs;
T = linspace(-1*Pulse_width/2, 1*Pulse_width/2, N_Points);
j = sqrt(-1);
% 上变频 u为正数 未考虑载频的影响 实为低通型信号
S = exp(j*pi*(Band/Pulse_width)*T.^2);
% 时域波形图
figure (1);
subplot(2,1,1);
plot(T/1e-6, real(S),'LineWidth', 1.2);
axis([-Pulse_width/(2*1e-6), Pulse_width/(2*1e-6), -1, 1]);
grid on;
xlabel('t/microseconds');
ylabel('Amplitude');
title('The Real Part of LFM Waves');
subplot(2,1,2);
plot(T/1e-6, imag(S), 'LineWidth', 1.2);
axis([-Pulse_width/(2*1e-6), Pulse_width/(2*1e-6), -1, 1]);
grid on;
xlabel('t/microseconds');
ylabel('Amplitude');
title('The Imag Part of LFM Waves');
% 频域波形图
% 频谱的横轴坐标转换
N = 2^(nextpow2(length(T))); % 补0运算
Frequency = (-(N/2-1):1:(N/2))*Fs/N;
S_FFT = fftshift(fft(S, N));% 取模 展示为幅度谱
figure (2);
plot(Frequency/1e6, abs(S_FFT)/N, 'LineWidth', 1.2);
xlabel('f/Mhz');
ylabel('Amplitude');
title('Spectrum of LFM Waves');
grid on;

% --- Executes on button press in Quit.
function Quit_Callback(hObject, eventdata, handles)
% hObject    handle to Quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;
