function varargout = control_coperativo(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @control_coperativo_OpeningFcn, ...
                   'gui_OutputFcn',  @control_coperativo_OutputFcn, ...
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


% --- Executes just before control_coperativo is made visible.
function control_coperativo_OpeningFcn(hObject, eventdata, handles, varargin)
global puertos puerto mv1 mv2 RVM1
global Servo_1 Servo_2 Servo_3 Servo_4 Servo_5 Servo_6 


handles.output = hObject;
            
% Definir Variables del Entorno Virtual ------
mv1 = vrworld('brazo.wrl');
mv2 = vrworld('rvm1.wrl');
%---------------------------------------------

% Abrir Entorno Virtual ----------------------
open(mv1); reload(mv1);
open(mv2); reload(mv2);
%---------------------------------------------

% Muestra Mundo Virtual Dentro de una Figura -----
fig1 = figure('name','Mundo Virtual 1', 'MenuBar', 'none');
fig2 = figure('name','Mundo Virtual 2', 'MenuBar', 'none');
vr.canvas(mv1, fig1);
vr.canvas(mv2, fig2);
%-------------------------------------------------
% Update handles structure

warning off; %#ok<WNOFF>
serialinfo = instrhwinfo('serial');
puertos = serialinfo.AvailableSerialPorts;
[f, v] = size(puertos);

% Asignación inicial de puerto a RVM1
set(handles.serialList_SCARA,'String', puertos);
if f > 1
    set(handles.serialList_SCARA,'Value', f);
    puerto = puertos{f,1};
else
    set(handles.serialList_SCARA,'Value', f);
    puerto = puertos{f,1};
end

Servo_1 = 3;
Servo_2 = 5;
Servo_3 = 6;
Servo_4 = 9;
Servo_5 = 10;
Servo_6 = 11;
%

warning off; %#ok<WNOFF>
serialinfo = instrhwinfo('serial');
puertos = serialinfo.AvailableSerialPorts;
[f, v] = size(puertos);

RVM1 = class_RVM1;

% Asignación inicial de puerto a RVM1
set(handles.serialList_RVM1,'String', puertos);
if f > 1
    set(handles.serialList_RVM1,'Value', f-1);
    RVM1.setCOM(puertos{f-1,1})
else
    set(handles.serialList_RVM1,'Value', f);
    RVM1.setCOM(puertos{f,1})
end
% ------------------------------------

% Parametros de inicio realidad virtual
mv2.Body.rotation      = [0 1 0 0];
mv2.Upperarm.rotation  = [0 0 1 0];
mv2.Forearm.rotation   = [0 0 1 0];
mv2.Wrist.rotation     = [0 0 1 0];
mv2.Muneca.rotation    = [1 0 0 0];
% ------------------------------------
%
axes(handles.escudo);
imshow('UdeSantiago.jpg')

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = control_coperativo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Programación Robot Mitsubishi RV-M1 %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in Conectar_rvm1.
function Conectar_rvm1_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Connect();
set(handles.Led_Conexion_rvm1,'BackGroundColor', [1,0,0]);
 updateCinematicaDirecta(handles);


% --- Executes on slider movement.
function th1_rvm1_Callback(hObject, eventdata, handles)
global RVM1 mv2 th1M;
th1M = RVM1.ReadRVM1('th1');
angBodyY = get(handles.th1_rvm1,'Value');
if angBodyY < -150; angBodyY = -150; end
if angBodyY > 150; angBodyY = 150; end
angBodyY_Inc = round(angBodyY - th1M);
RVM1.AngleTh1(angBodyY_Inc);
mv2.Body.rotation = [0 -1 0 angBodyY*(pi/180)];
set(handles.th1M,'String',angBodyY);
updateCinematicaDirecta(handles);


% --- Executes during object creation, after setting all properties.
function th1_rvm1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th2_rvm1_Callback(hObject, eventdata, handles)
global RVM1 mv2 th2M;
th2M = RVM1.ReadRVM1('th2');
angUpperarmZ = get(handles.th2_rvm1,'Value');
if angUpperarmZ > 100; angUpperarmZ = 100; end
if angUpperarmZ < -30; angUpperarmZ = -30; end
angUpperarmZ_Inc = round(angUpperarmZ - th2M);
RVM1.AngleTh2(angUpperarmZ_Inc);
mv2.Upperarm.rotation = [0 0 1 angUpperarmZ*(pi/180)];
set(handles.th2M,'String',angUpperarmZ)
updateCinematicaDirecta(handles);


% --- Executes during object creation, after setting all properties.
function th2_rvm1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th3_rvm1_Callback(hObject, eventdata, handles)
global RVM1 mv2 th3M;
th3M = RVM1.ReadRVM1('th3');
angForearmZ =  get(handles.th3_rvm1,'Value');
if angForearmZ > 0;    angForearmZ = 0;    end
if angForearmZ < -100; angForearmZ = -100; end
angForearmZ_Inc = round(angForearmZ - th3M);
RVM1.AngleTh3(angForearmZ_Inc);
mv2.Forearm.rotation = [0 0 1 angForearmZ*(pi/180)];

set(handles.th3M,'String',angForearmZ);
updateCinematicaDirecta(handles);

% --- Executes during object creation, after setting all properties.
function th3_rvm1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th4_rvm1_Callback(hObject, eventdata, handles)
global RVM1 mv2 th4M;
th4M = RVM1.ReadRVM1('th4');
angWristZ = get(handles.th4_rvm1,'Value');
if angWristZ > 90;  angWristZ =  90; end
if angWristZ < -90; angWristZ = -90; end
angWristZ_Inc = round(angWristZ - th4M);
RVM1.AngleTh4(angWristZ_Inc);
mv2.Wrist.rotation = [0 0 1 angWristZ*(pi/180)];
set(handles.th4M,'String',angWristZ);
updateCinematicaDirecta(handles);


% --- Executes during object creation, after setting all properties.
function th4_rvm1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th5_rvm1_Callback(hObject, eventdata, handles)
global RVM1 mv2 th5M;
th5M = RVM1.ReadRVM1('th5');
angMunecaX =  get(handles.th5_rvm1,'Value');
if angMunecaX > 180;  angMunecaX = 180; end
if angMunecaX < -180; angMunecaX = -180; end
angMunecaX_Inc = round(angMunecaX-th5M);
RVM1.AngleTh5(angMunecaX_Inc);
mv2.Muneca.rotation = [1 0 0 angMunecaX*(pi/180)];
set(handles.th5M,'String',angMunecaX);
updateCinematicaDirecta(handles);


% --- Executes during object creation, after setting all properties.
function th5_rvm1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in reset_rvm1.
function reset_rvm1_Callback(hObject, eventdata, handles)
global  angBodyY  angBodyY_temp mv2;
global angUpperarmZ_temp angUpperarmZ;
global angForearmZ angForearmZ_temp;
global angWristZ angWristZ_temp;
global angMunecaX angMunecaX_temp;
global RVM1 ;
RVM1.RS();
RVM1.OG();

angBodyY = 0; 
set(handles.th1_rvm1,'Value',0);
angBodyY_temp = 0;
mv2.Body.rotation = [0 1 0 0];

angUpperarmZ = 0; 
set(handles.th2_rvm1,'Value',0);
angUpperarmZ_temp = 0;
mv2.Upperarm.rotation = [0 0 1 0];

angForearmZ = 0; 
set(handles.th3_rvm1,'Value',0);
angForearmZ_temp = 0;
mv2.Forearm.rotation = [0 0 1 0];

angWristZ = 0; 
set(handles.th4_rvm1,'Value',0);
angWristZ_temp = 0;
mv2.Wrist.rotation = [0 0 1 0];

angMunecaX = 0; 
set(handles.th5_rvm1,'Value',0);
angMunecaX_temp = 0;
mv2.Muneca.rotation = [1 0 0 0];

set(handles.th1M,'String',angBodyY);
set(handles.th2M,'String',angUpperarmZ);
set(handles.th3M,'String',angForearmZ);
set(handles.th4M,'String',angWristZ);
set(handles.th5M,'String',angMunecaX);
updateCinematicaDirecta(handles);

function  updateCinematicaDirecta(handles)
global RVM1 
[x, y, z, p, r] = RVM1.xyzpr();
set(handles.valor_xM,'String',x)
set(handles.valor_yM,'String',y);
set(handles.valor_zM,'String',z);
set(handles.valor_pitchM,'String',p);
set(handles.valor_rollM,'String',r);

function Led_Conexion_rvm1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Led_Conexion_rvm1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in serialList_RVM1.
function serialList_RVM1_Callback(hObject, eventdata, handles)
global RVM1 puertos;
seleccion = get(handles.serialList_RVM1,'Value');
RVM1.setCOM(puertos{seleccion,1});
assignin('base','com_RVM1', RVM1.PortName);


% --- Executes during object creation, after setting all properties.
function serialList_RVM1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Desconectar_RVM1.
function Desconectar_RVM1_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Disconnect();
set(handles.Led_Conexion_rvm1, 'BackgroundColor', [0.941 0.941 0.941]);


% --- Executes on button press in Origen_Mecanico.
function Origen_Mecanico_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.NT();


% --- Executes on button press in Origen_XYZ.
function Origen_XYZ_Callback(hObject, eventdata, handles)
reset_rvm1_Callback(hObject, eventdata, handles)
pause(1);
updateCinematicaDirecta(handles);


% --- Executes on button press in Abrir_Mano.
function Abrir_Mano_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.GO();
pause(1);


% --- Executes on button press in Cerrar_Mano.
function Cerrar_Mano_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.GC();
pause(1);


% --- Executes on button press in tool.
function tool_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.TOOL();
TOOL = get(handles.editTool, 'String');
pause(1);
RVM1.Bip(1);


function editTool_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editTool_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rvm1Slow.
function rvm1Slow_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Slow();


% --- Executes on button press in rvm1Fast.
function rvm1Fast_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Fast();



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Programación Robot Tipo SCARA  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in Conectar_scara.
function Conectar_scara_Callback(hObject, eventdata, handles)
global SCARA puerto;

 SCARA = arduino(puerto);

set(handles.Led_Conexion_scara,'BackGroundColor', [1,0,0]);
Bip(1);


% --- Executes on slider movement.
function th1_s_Callback(hObject, eventdata, handles)
global  SCARA Servo_1 mv1 th1;
servoAttach(SCARA,Servo_1);
th1 = round(get(handles.th1_s,'Value'));
set(handles.edit_th1s, 'String',num2str(th1));
servoWrite(SCARA,Servo_1,th1+90);
mv1.base_2_2.rotation = [0 1 0 th1*(pi/180)];
pause(0.3);
if th1 >= 90
servoDetach(SCARA,Servo_1);
end
if th1 <= -90
    servoDetach(SCARA,Servo_1);
end
 valor_xyz_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function th1_s_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th2_s_Callback(hObject, eventdata, handles)
global SCARA Servo_2 mv1 ;

th2 = round(get(handles.th2_s,'Value'));
set(handles.edit_th2s,'String', num2str(th2));
servoAttach(SCARA,Servo_2);
servoWrite(SCARA,Servo_2,th2+90);
mv1.base_2_7.rotation = [0 1 0 th2*(pi/180)];
pause(0.3);
if th2 >= 90
servoDetach(SCARA,Servo_2);
end
if th2 <= -90
    servoDetach(SCARA,Servo_2);
end
valor_xyz_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function th2_s_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th3_s_Callback(hObject, eventdata, handles)
global SCARA Servo_3 mv1;
servoAttach(SCARA,Servo_3);
th3 = round(get(handles.th3_s,'Value'));
set(handles.edit_th3s,'String', num2str(th3));
servoWrite(SCARA,Servo_3,th3+90);
mv1.base_3_5.rotation = [0 1 0 th3*(pi/180)];
pause(0.3);
if th3 >= 90
servoDetach(SCARA,Servo_3);
end
if th3 <= -90
    servoDetach(SCARA,Servo_3);
end
valor_xyz_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function th3_s_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th4_s_Callback(hObject, eventdata, handles)
global SCARA Servo_4 th4 mv1;
servoAttach(SCARA,Servo_4);
th4 = round(get(handles.th4_s,'Value'));
set(handles.edit_th4s,'String', num2str(th4));
servoWrite(SCARA,Servo_4,th4);
mv1.cremallera.translation = [0 -th4*(pi/180)*10 0 ];
pause(0.5);
if th4 == 180
servoDetach(SCARA,Servo_4);
end
if th4 == 0
    servoDetach(SCARA,Servo_4);
end
valor_xyz_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function th4_s_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function th5_s_Callback(hObject, eventdata, handles)
global SCARA Servo_5 th5 mv1;
servoAttach(SCARA,Servo_5);
th5 = round(get(handles.th5_s,'Value'));
set(handles.edit_th5s,'String', num2str(th5));
% set(handles.valor_Roll, 'String', num2str(th5));
servoWrite(SCARA,Servo_5,th5+90);
mv1.mano_1.rotation = [0 1 0 th5*(pi/180)];
pause(0.3);
if th5 >= 90
servoDetach(SCARA,Servo_5);
end
if th5 <= -90
    servoDetach(SCARA,Servo_5);
end
valor_xyz_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function th5_s_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function th6_s_Callback(hObject, eventdata, handles)
global SCARA Servo_6 mv1;
servoAttach(SCARA,Servo_6);
th6 = round(get(handles.th6_s,'Value'));
set(handles.edit_th6s,'String', num2str(th6));
servoWrite(SCARA,Servo_6,th6);
mv1.dedo_1.translation = [-th6*(pi/180)*20 0 0 ];
mv1.dedo_2.translation = [th6*(pi/180)*20 0 0 ];
pause(0.3);
if th6 >= 45
servoDetach(SCARA,Servo_6);
end
if th6 <= 0
    servoDetach(SCARA,Servo_6);
end
valor_xyz_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function th6_s_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in reset_scara.
function reset_scara_Callback(hObject, eventdata, handles)
global SCARA Servo_1  Servo_2 Servo_3;
global  Servo_4 Servo_5 Servo_6 mv1 th1 th2 th3 th4 th5 th6; 

servoAttach(SCARA,Servo_1);
servoAttach(SCARA,Servo_2);
servoAttach(SCARA,Servo_3);
servoAttach(SCARA,Servo_4);
servoAttach(SCARA,Servo_5);
servoAttach(SCARA,Servo_6);

th1 = 0;
th2 = 0;
th3 = 0;
th4 = 0;
th5 = 0;
th6 = 0;

set(handles.th1_s, 'Value', th1);
set(handles.th2_s, 'Value', th1);
set(handles.th3_s, 'Value', th3);
set(handles.th4_s, 'Value', th4);
set(handles.th5_s, 'Value', th5);
set(handles.th6_s, 'Value', th6);

set(handles.edit_th1s, 'String',num2str(th1));
servoWrite(SCARA,Servo_1,90);
set(handles.edit_th2s,'String', num2str(th2));
servoWrite(SCARA,Servo_2,90);
set(handles.edit_th3s,'String', num2str(th3));
servoWrite(SCARA,Servo_3,90);
set(handles.edit_th4s,'String', num2str(th4));
servoWrite(SCARA,Servo_4,0);
set(handles.edit_th5s,'String', num2str(th5));
% set(handles.valor_Roll,'String',num2str(th5));
servoWrite(SCARA,Servo_5,0);
set(handles.edit_th6s,'String', num2str(th6));
servoWrite(SCARA,Servo_6,0);

mv1.base_2_2.rotation = [0 1 0 th1*(pi/180)];
mv1.base_2_7.rotation = [0 1 0 th2*(pi/180)];
mv1.base_3_5.rotation = [0 1 0 th3*(pi/180)];
mv1.cremallera.translation = [0 th4*(pi/180)*30 0 ];
mv1.mano_1.rotation = [0 1 0 th5*(pi/180)];
mv1.dedo_1.translation = [th6*(pi/180)*5 0 0 ];
mv1.dedo_2.translation = [th6*(pi/180)*5 0 0 ];
pause(0.3);

if th1 == 90
servoDetach(SCARA,Servo_1);
end
if th2 == 90
servoDetach(SCARA,Servo_2);
end
if th3 == 90
servoDetach(SCARA,Servo_3);
end
if th4 == 0
servoDetach(SCARA,Servo_4);
end
if th5 == 0
servoDetach(SCARA,Servo_5);
end
if th6 == 0
servoDetach(SCARA,Servo_6);
end
valor_xyz_Callback(hObject, eventdata, handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)


function Led_Conexion_scara_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Led_Conexion_scara_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in serialList_SCARA.
function serialList_SCARA_Callback(hObject, eventdata, handles)
global SCARA puertos;
seleccion = get(handles.serialList_SCARA,'Value');
SCARA.setCOM(puertos{seleccion,1});
assignin('base','com_SCARA', SCARA.PortName);


% --- Executes during object creation, after setting all properties.
function serialList_SCARA_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in desconectar_scara.
function desconectar_scara_Callback(hObject, eventdata, handles)
global SCARA;
delete(SCARA);
Bip(2);
set(handles.Led_Conexion_scara, 'BackgroundColor', [0.941 0.941 0.941]);


function Bip(n)
for i = 1:n
    cf = 2000;                  % carrier frequency (Hz)
    sf = 22050;                 % sample frequency (Hz)
    d = 0.1;                    % duration (s)
    n = sf * d;                 % number of samples
    s = (1:n) / sf;             % sound data preparation
    s = sin(2 * pi * cf * s);   % sinusoidal modulation
    sound(s, sf);               % sound presentation
    pause(d);                   % waiting for sound end
end


function valor_xyz_Callback(hObject, eventdata, handles)
global x y z phi roll th1 th2 th3 th4 th5 th6 
th1 = round(get(handles.th1_s,'Value'));
th2 = round(get(handles.th2_s,'Value'));
th3 = round(get(handles.th3_s,'Value'));
th4 = round(get(handles.th4_s,'Value'));
th5 = round(get(handles.th5_s,'Value'));
th6 = round(get(handles.th6_s,'Value'));

[x,y,z,phi,roll]=cine_dir_scara( th1,th2,th3,th4,th5,th6);
 set(handles.valor_x,'String',x);
 set(handles.valor_y,'String',y);
 set(handles.valor_z,'String',z);
 set(handles.valor_phi,'String',phi);


 % --- Executes on button press in abrir_mano_scara.
function abrir_mano_scara_Callback(hObject, eventdata, handles)
% hObject    handle to abrir_mano_scara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cerrar_mano_scara.
function cerrar_mano_scara_Callback(hObject, eventdata, handles)
% hObject    handle to cerrar_mano_scara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
 
 

function edit_th1s_Callback(hObject, eventdata, handles)
% hObject    handle to edit_th1s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_th1s as text
%        str2double(get(hObject,'String')) returns contents of edit_th1s as a double


% --- Executes during object creation, after setting all properties.
function edit_th1s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th1s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_th2s_Callback(hObject, eventdata, handles)
% hObject    handle to edit_th2s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_th2s as text
%        str2double(get(hObject,'String')) returns contents of edit_th2s as a double


% --- Executes during object creation, after setting all properties.
function edit_th2s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th2s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_th3s_Callback(hObject, eventdata, handles)
% hObject    handle to edit_th3s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_th3s as text
%        str2double(get(hObject,'String')) returns contents of edit_th3s as a double


% --- Executes during object creation, after setting all properties.
function edit_th3s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th3s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_th4s_Callback(hObject, eventdata, handles)
% hObject    handle to edit_th4s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_th4s as text
%        str2double(get(hObject,'String')) returns contents of edit_th4s as a double


% --- Executes during object creation, after setting all properties.
function edit_th4s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th4s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_th5s_Callback(hObject, eventdata, handles)
% hObject    handle to edit_th5s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_th5s as text
%        str2double(get(hObject,'String')) returns contents of edit_th5s as a double


% --- Executes during object creation, after setting all properties.
function edit_th5s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th5s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_th6s_Callback(hObject, eventdata, handles)
global SCARA Servo_6 mv1 th6;
th6 = str2double( get(handles.edit_th6s, 'String'));
set(handles.th6_s, 'Value', th6);
% set(handles.valor_Roll, 'Value', th5);
servoWrite(SCARA,Servo_6,th6);
mv1.dedo_1.translation = [th6*(pi/180)*5 0 0 ];
mv1.dedo_2.translation = [th6*(pi/180)*5 0 0 ];
valor_xyz_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_th6s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_th6s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function valor_x_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function valor_x_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valor_y_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function valor_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valor_z_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function valor_z_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valor_phi_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function valor_phi_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valor_Roll_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function valor_Roll_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Programación Común  %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in salir.
function salir_Callback(hObject, eventdata, handles)
global SCARA ;
global mv1 mv2 fig1 fig2;

delete(SCARA);

close(fig1);
close(fig2);
try 
    delete(mv1);
    delete(mv2);
catch
end
closereq;
close;
close();


% --- Executes on selection change in tarea.
function tarea_Callback(hObject, eventdata, handles)
global RVM1 
global SCARA Servo_1  Servo_2 Servo_3;
global  Servo_4 Servo_5 Servo_6 mv2 mv1 th1 th2 th3 th4 th5 th6; 

str = get(hObject, 'String');
val = get(hObject,'Value');
switch str{val};

    case 'CUADRADO'

 th1 = 45;
 th2 = -30;
 th3 = 90;
  
set(handles.th1_s, 'Value',th1);
th1_s_Callback(hObject, eventdata, handles);
pause (1);
set(handles.th2_s, 'Value',th2);
th2_s_Callback(hObject, eventdata, handles);
pause (1);
set(handles.th3_s, 'Value',th3);
th3_s_Callback(hObject, eventdata, handles);
pause (1);       
        
        
RVM1.OG();   
RVM1.waitPortFree();
th_1 = 90;
th_2 = 78.7;
th_3 = -87;
th_4 = -41.7;
th_5 = 0;

RVM1.AngleTh12345(th_1,th_2,th_3,th_4,th_5);
RVM1.waitPortFree();
th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();

th_1=90;
th_2 = 53.5;
th_3 = -45.9;
th_4 = -57.6;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();
th_1 = 102.5;
th_2 = 49.8;
th_3 = -38.6;
th_4 = -61.2;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();

th_1 = 105.9;
th_2 = 75.5;
th_3 = -82.7;
th_4 = -42.8;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();

th_1 = 90;
th_2 = 78.7;
th_3 = -87;
th_4 = -41.7;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

    case 'HEXAGONO'
        
th1 = 45;
th2 = 45;
th3 = -30;
th4 = 25;
th5 = 180;
RVM1.AngleTh12345(th1,th2,th3,th4,th5);

%{
RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta5, 'Value',th5);
Theta5_Callback(hObject, eventdata, handles);

th1 = 0;
th4 = -45;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 45;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 0;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);   
  
%}

    case 'ROMBO'
        
th1 = 45;
th2 = 45;
th3 = -30;
th4 = 25;
th5 = 180;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta5, 'Value',th5);
Theta5_Callback(hObject, eventdata, handles);

th1 = 0;
th4 = -45;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 45;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 0;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles); 


    case 'COOPERACION_1'
        
th1 = 45;
th2 = 45;
th3 = -30;
th4 = 25;
th5 = 180;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta5, 'Value',th5);
Theta5_Callback(hObject, eventdata, handles);

th1 = 0;
th4 = -45;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 45;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 0;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);   
end


% --- Executes during object creation, after setting all properties.
function tarea_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
