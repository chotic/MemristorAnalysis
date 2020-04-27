
clear
%By entering the path of a folder, this code finds all the csv file with a
%specific diameter and range of voltage (which is given by user)and plot
%the current density versus volatage of all these files and the logarithm
%scale of the current density versus volatages.

%receives the path of the file and converte it to a string
path=input('what is the path of the folder: ' ,'s');

%receives the diameter of the electrode in the form of 0p00, such as 1p00,
diameter=input('what is the diamete of the electrode in mm: ','s');

%receives the range of the voltage, only the value such as 2.
range_voltage=input('what is the range of voltage: ','s'); 

%find files with a specific diameter and voltage range
files=dir(strcat(path,'\','*',diameter,'mm','*',range_voltage,'v','*','.csv'));


cell_files = cell(length(files));



for index=1:length(files)
    data=readmatrix(strcat(files(index).folder,'\',files(index).name));
    cell_files{index}.r=data(:,1);
    cell_files{index}.v=data(:,3);
    cell_files{index}.I=data(:,4);
    cell_files{index}.t=data(:,5);
    cell_files{index}.D=GetElectrodeDiameter(strcat(files(index).folder,'\',files(index).name));
    plot_IV(cell_files{index}.v,cell_files{index}.I,cell_files{index}.r,cell_files{index}.D)
    
end  

%add legeng based on the scan rate of each measurement.
cell_legend=cell(length(files),1);
for i=1:length(files)
    cell_legend{i}=scan_rate(cell_files{i}.v,cell_files{i}.t);
end
legend(cell_legend,'location','southwest')

%this fuction calculats the diameter based on the namefile
function c = GetElectrodeDiameter(namefile)
a=extractBefore(namefile,'mm');
b=a((length(a)-3):end);
b(2)='.';
c=str2double(b);
end


function str=scan_rate(v,t)

for i=1:length(v)
    if ( v(i)>v(i+1)&& v(i+1)>v(i+2))
        index_max=i; 
        break;
    end
end

scan_rate=string(round((v(1)-v(index_max))/(t(1)-t(index_max)),3));
str=strcat('scan rate = ',scan_rate,' V/s');

end


function plot_IV(v,I,r,D) 

counter=0;
for i=1:length(r)
    if ( r(i)==1)
        counter=i;
    else
        break;
    end
end


v=v(1:counter);
I=I(1:counter);



 
A= 10^-2* pi*(D/2)^2; 
I_dens=10^3*I./A ; %change current to Current density (mA.cm^-2)


figure(1)
plot(v,I_dens,'LineWidth',3)

 xlim([-2.2 2.2])
title('ITO/MAPbI(500nm)/Al')
xlabel('Voltage(V)')
ylabel('Current Density(mA.cm^-3)')

saveas(gcf,'Figures\0p05mm-2v-cc-3-long-1r.bmp') 

hold on

 figure(2)
 semilogy(v,abs(I_dens),'LineWidth',3)

  xlim([-2.2 2.2])
 title('ITO/MAPbI(500nm)/Al')
 xlabel('Voltage(V)')
 ylabel('Current Density(mA.cm^-3)')
 saveas(gcf,'Figures\0p05mm-2v-cc-3-long-1r.bmp')
    
    hold on
end
    
