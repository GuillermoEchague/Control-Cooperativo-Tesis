function [ x, y, z, phi, roll] = cine_dir_scara( th1,th2,th3,th4,th5,th6)

if and(th1 >= -90, th1 <= 90)
else
    error('error fatal... th1 no está en el intervalo')
end 

if and(th2 >= -90, th2 <= 90)
else
    error('error fatal... th2 no está en el intervalo')
end 

if and(th3 >= -90, th3 <= 90)
else
    error('error fatal... th3 no está en el intervalo')
end

if and(th4 >= 0, th4 <= 180)
else
    error('error fatal... th4 no está en el intervalo')
end 

if and(th5 >= -90, th5 <= 90)
else
    error('error fatal... th5 no está en el intervalo')
end

if and(th6 >= 0, th6 <= 180)
else
    error('error fatal... th6 no está en el intervalo')
end 


a1=190;
a2=190;
a3=190;
d1=500;

x =a2*cosd(th1+th2)+a3*cosd(th1+th2+th3)+a1*cosd(th1); 
y =a2*sind(th1+th2)+a3*sind(th1+th2+th3)+a1*sind(th1);
z = d1-30*th4*pi()/180;

phi=th1+th2+th3;
roll=th6;
re_x = real(x);
re_y = real(y);
re_z = real(z);
re_phi = real(phi);
re_roll = real(roll);

ent_x = fix(re_x);
ent_y = fix(re_y);
ent_z = fix(re_z);
ent_phi = fix(re_phi);
ent_roll = fix(re_roll);

dec_x = round((re_x-ent_x)*10)*0.1;
dec_y = round((re_y-ent_y)*10)*0.1;
dec_z = round((re_z-ent_z)*10)*0.1;
dec_phi = round((re_phi-ent_phi)*10)*0.1;
dec_roll = round((re_roll-ent_roll)*10)*0.1;

x = ent_x+dec_x;
y = ent_y+dec_y;
z = ent_z+dec_z;
phi = ent_phi+dec_phi;
roll = ent_roll+dec_roll;
%[x,y,z,phi,roll];
end
