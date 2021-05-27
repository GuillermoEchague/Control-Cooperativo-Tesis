function[x,y,z,th_pitch,th_roll]=cine_dir5(th1,th2,th3,th4,th5)
if and(th1 >= -150, th1 <= 150)
else
    error('error fatal... th1 no está en el intervalo')
end 
if and(th2 >= -30, th2 <= 100)
else
    error('error fatal... th2 no está en el intervalo')
end

if and(th3 >= -110, th3 <= 0)
else
    error('error fatal... th3 no está en el intervalo')
end

if and(th4 >= -90, th4 <= 90)
else
    error('error fatal... th4 no está en el intervalo')
end

if and(th5 >= -180, th5 <= 180)
else
    error('error fatal... th5 no está en el intervalo')
end

a2=250;
a3=160;
p=72;
% m=0;
m=150;
dg=p+m;
d1=300;
x=sind(th1).*(a2*cosd(th2)-sind(th2).*(a3.*sind(th3)+dg*sind(th3+th4))+cosd(th2).*(a3.*cosd(th3)+dg.*cosd(th3+th4)));
y=cosd(th1).*(a2*cosd(th2)-sind(th2).*(a3.*sind(th3)+dg.*sind(th4+th3))+cosd(th2).*(a3.*cosd(th3)+dg.*cosd(th3+th4)));
z=d1+a2.*sind(th2)+cosd(th2).*(a3.*sind(th3)+dg*sind(th3+th4))+sind(th2).*(a3.*cosd(th3)+dg.*cosd(th3+th4));
th_pitch=th2+th3+th4;
th_roll=th5;

[x,y,z,th_pitch,th_roll]
 