classdef class_RVM1 < handle
    properties
        PortName    = 'COM3';
        BaudRate    = 9600;
        DataBits    = 7; 
        StopBits    = 2;
        Parity      = 'even';
        FlowControl = 'hardware';
        Terminator  = 'CR';
        serialPort;
    end
    methods
        % Función que cambia puerto COM a utilizar
        function obj = setCOM(obj,comPort)
            obj.PortName = comPort;
        end
        
        % Función que conecta a robot RVM1
        function obj = Connect(obj)
            obj.serialPort = serial(obj.PortName,... 
                             'BaudRate',    obj.BaudRate,...
                             'DataBits',    obj.DataBits,...
                             'StopBits',    obj.StopBits,...
                             'Parity',      obj.Parity,...
                             'FlowControl', obj.FlowControl,... 
                             'Terminator',  obj.Terminator);
            try
                fopen(obj.serialPort);
                pause(1);
                obj.Bip(1);
                disp('Conectado a unidad RVM1.');
            catch error
                disp(error);
                disp('Verifique puerto serial, unidad RVM1 desconectada.');
            end    
        end
        
        % Función que resetea error en robot RVM1
        function obj = RS(obj)
            fprintf(obj.serialPort, 'RS');
            pause(1); 
        end
        
        % Función que lleva al origen de coordenadas al robot RVM1
        function obj = OG(obj)
            fprintf(obj.serialPort, 'OG');
            pause(.04); 
        end
        
        % Función que lleva al origen mecánico al robot RVM1
        function obj = NT(obj)
            fprintf(obj.serialPort, 'NT');
            pause(.04); 
        end
        
        % Función que cierra manipulador de robot RVM1
        function obj = GC(obj)
            fprintf(obj.serialPort, 'GC');
            pause(.04); 
        end
        
        % Función que abre manipulador de robot RVM1
        function obj = GO(obj)
            fprintf(obj.serialPort, 'GO');
            pause(.04); 
        end
        
        % Función que setea a velocidad media el robot RVM1
        function obj = Slow(obj)
            fprintf(obj.serialPort, 'SP 6,L');
            pause(.04); 
        end
                
        % Función que setea a maxima velocidad el robot RVM1
        function obj = Fast(obj)
            fprintf(obj.serialPort, 'SP 9,H');
            pause(.04); 
        end
               
        % Función que setea angulo TH1 del robot RVM1
        function obj = AngleTh1(obj, ang)
            cmd = ['MJ ' num2str(ang) ', 0, 0, 0, 0 '];
            fprintf(obj.serialPort, cmd);
            pause(.04); 
        end
        
        % Función que setea angulo TH2 del robot RVM1
        function obj = AngleTh2(obj, ang)
            cmd = ['MJ ' '0,' num2str(ang) ', 0, 0, 0 '];
            fprintf(obj.serialPort, cmd);
            pause(.04); 
        end
        
         % Función que setea angulo TH3 del robot RVM1
        function obj = AngleTh3(obj, ang)
            cmd = ['MJ ' '0, 0,' num2str(ang) ', 0, 0 '];
            fprintf(obj.serialPort, cmd);
            pause(.04); 
        end
        
        
         % Función que setea angulo TH4 del robot RVM1
        function obj = AngleTh4(obj, ang)
            cmd = ['MJ ' '0, 0, 0,' num2str(ang) ', 0 '];
            fprintf(obj.serialPort, cmd);
            pause(.04); 
        end
        
         % Función que setea angulo TH5 del robot RVM1
        function obj = AngleTh5(obj, ang)
            cmd = ['MJ ' '0, 0, 0, 0, ' num2str(ang)];
            fprintf(obj.serialPort, cmd);
            pause(.04); 
        end
        
        
        % Función que setea angulo TH1 y TH2 del robot RVM1
        function obj = AngleTh12(obj, ang1, ang2)
            cmd = ['MJ ' num2str(ang1) ', ' num2str(ang2) ', 0, 0, 0 '];
            fprintf(obj.serialPort, cmd);
            pause(.04); 
            if strcmp(obj.serialPort.pinStatus.ClearToSend, 'on')
                obj.RS();
            end
        end
        
         % Función que setea angulo TH1, TH2, TH3, TH4 y TH5 del robot RVM1
        function obj = AngleTh12345(obj, ang1, ang2, ang3, ang4, ang5)
            cmd = ['MJ ' num2str(ang1) ', ' num2str(ang2) ', ' num2str(ang3) ', ' num2str(ang4) ', ' num2str(ang5)];
            fprintf(obj.serialPort, cmd);
            pause(.04); 
            if strcmp(obj.serialPort.pinStatus.ClearToSend, 'on')
                obj.RS();
            end
        end
        
        function [x, y, z, p, r] = xyzpr(obj)
            while obj.PortStatus() == 0; end
            fprintf(obj.serialPort, 'WH');
            pause(0.04);
            [tline,count,msg] = fgetl(obj.serialPort);
            %assignin('base','Coordenadas',tline);
            [x, y, z, p, r] = strread(tline, '%f %f %f %f %f', 'delimiter', ',');
            pause(0.04); 
        end
                
        
        % Función que lee coordenadas de robot RVM1
        function ang = ReadRVM1(obj,cmd)
            while obj.PortStatus() == 0; end
            fprintf(obj.serialPort, 'WH');
            pause(0.04);
            [tline,count,msg] = fgetl(obj.serialPort);
            %assignin('base','Coordenadas',tline);
            [x, y, z, p, r] = strread(tline, '%f %f %f %f %f', 'delimiter', ',');
            [th1, th2, th3, th4, th5] = cine_inv5(x,y,z,p,r);
            switch cmd
                case 'th1'
                    ang = th1;
                case 'th2'
                    ang = th2;
                case 'th3'
                    ang = th3;
                case 'th4'
                    ang = th4;
                case 'th5'
                    ang = th5;
                otherwise
                    ang = [th1 th2 th3 th4 th5];
            end
            pause(0.04);
%             if strcmp(obj.serialPort.pinStatus.ClearToSend, 'on')
%                 obj.RS();
%             end
        end
        
        % Función que Setea el largo de la herramienta
        function obj = TOOL(obj)
            fprintf(obj.serialPort, 'TL');
            pause(.04); 
        end
        
        % Función que genera un bip en el Drive Unit del robot RVM1
        function Bip(obj, n)
            for i = 1:n
                fprintf(obj.serialPort, 'PD ');
                pause(.04);
                fprintf(obj.serialPort, 'RS ');
                pause(.04); 
            end
        
        end
        
        % Función que comprueba que el puerto de comunicaciones esté libre
        function  Status = PortStatus(obj)
            Status = strcmp(obj.serialPort.pinStatus.ClearToSend,'on');
        end
        
        % Función que comprueba que el puerto de comunicaciones esté libre
        function  Status = waitPortFree(obj)
            while obj.PortStatus() == 0; end
        end
        
        % Función que desconecta de la unidad RVM1
        function st = Disconnect(obj)
            try
                fclose(obj.serialPort);
                st = 1;
            catch
                st = 0;
            end
            disp('Puerto serial cerrado');
        end
    end
end