function[th1,th2,th3,th4,th5,th_pitch]=cine_inv5(x,y,z,th_pich,th_roll)

a2=250;
a3=160;
p=72;
m=0;
% m=150;
dg=p+m;
d1=300;

th1=atan2d(x,y);

xw=x-dg*sind(th1).*cosd(th_pich);
yw=y-dg*cosd(th_pich)*cosd(th1);
zw=z-dg*sind(th_pich);

coseno=((((zw-d1)^2+xw^2+yw^2)-a2^2-a3^2)/(2*a2*a3));

th3=atand(-sqrt(1-coseno^2)/coseno);
if th3>0
    th3 = atand(sqrt(1-coseno^2)/coseno);
end

A=(zw-d1)/sqrt(xw^2+yw^2);
B=a3.*sind(th3)/(a2+a3*cosd(th3));
th2=atand(A)-atand(B);

if th2 > -30
A=(zw-d1)/sqrt(xw^2+yw^2);
th2=atand(A)-atand(B);
elseif th2 < 100
A=(zw-d1)/-sqrt(xw^2+yw^2);
th2=atand(A)-atand(B);
end

th4=th_pich-th2-th3;
th_pitch=th2+th3+th4;
th5=th_roll;

re_th1 = real(th1);
re_th2 = real(th2);
re_th3 = real(th3);
re_th4 = real(th4);
re_th5 = real(th5);

ent_th1 = fix(re_th1);
ent_th2 = fix(re_th2);
ent_th3 = fix(re_th3);
ent_th4 = fix(re_th4);
ent_th5 = fix(re_th5);

dec_th1 = round((re_th1-ent_th1)*10)*0.1;
dec_th2 = round((re_th2-ent_th2)*10)*0.1;
dec_th3 = round((re_th3-ent_th3)*10)*0.1;
dec_th4 = round((re_th4-ent_th4)*10)*0.1;
dec_th5 = round((re_th5-ent_th5)*10)*0.1;

th1 = ent_th1+dec_th1;
th2 = ent_th2+dec_th2;
th3 = ent_th3+dec_th3;
th4 = ent_th4+dec_th4;
th5 = ent_th5+dec_th5;
%  [th1,th2,th3,th4,th5]

end