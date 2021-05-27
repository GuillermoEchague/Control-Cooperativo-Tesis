function[th1,th2,th3,th4,th_phi]=cine_invscara(x,y,z,th_phi)

a1=130;
a2=130;
a3=130;
d1=500;
d2=d1-z;


xw=x-a3.*sind(th_phi);
yw=y-a3.*cosd(th_phi);
zw=d1-d2;


c2=(xw^2+yw^2-a1^2-a2^2)/(2*a1*a2);
    if  c2 < -1
        c2 = -1;
    end
    if  c2 > 1
        c2=1;     
    end

s2=sqrt(1-c2^2);

s1=((a1+a2*c2)*yw-a2*s2*xw)/(xw^2+yw^2);
c1=((a1+a2*c2)*xw+a2*s2*yw)/(xw^2+yw^2);

th1=atan2d(c1,s1);
if th1 > 90
    th1=90;
end
if th1 <-90
   th1=-90;
end

th3=atan2d(s2,c2);
if th3 > 90
    th3=90;
end
if th3 <-90
   th3=-90;
end

 th5=th_phi-th1-th3;
if th5 > 90
    th5=90;
end
if th5 <-90
   th5=-90;
end

re_th1 = real(th1);
re_th2 = real(th2);
re_th3 = real(th3);

ent_th1 = fix(re_th1);
ent_th2 = fix(re_th2);
ent_th3 = fix(re_th3);
 
dec_th1 = round((re_th1-ent_th1)*10)*0.1;
dec_th2 = round((re_th2-ent_th2)*10)*0.1;
dec_th3 = round((re_th3-ent_th3)*10)*0.1;
 
th1 = ent_th1+dec_th1;
th2 = ent_th2+dec_th2;
th3 = ent_th3+dec_th3;

fprintf(1,'%3.1f\n',th1);
fprintf(1,'%3.1f\n',th2);
fprintf(1,'%3.1f\n',th3);
fprintf(1,'%3.1f\n',th4);
fprintf(1,'%3.1f\n',th5);  
fprintf(1,'%3.1f\n',th6); 

end