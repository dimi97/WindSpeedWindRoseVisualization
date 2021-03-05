% ************************************
% * WindRose *
% * Pozoukidis Dimitrios 15016 *
% * CP 2020/2021 *
% ************************************
clear

%import file.
filename='Wind data.xlsx';
data=xlsread(filename);

%find min and max year from file.
years=data(:,1);
year_min=min(years);
year_max=max(years);

%randomly select a year between year_min and year_max-4.
year1=round(year_min+rand*(year_max-4-year_min));

%Get wind speed and direction data. 
%Convert wind speed from knots to m/s.
%Only winter data imported (DEC,JAN,FEB) for years year1-year1+4.
index=find(data(:,1)>=year1 & data(:,1)<=(year1+4) & (data(:,2)==12 | data(:,2)<=2));
speed=data(index,5)*0.51;
direction=data(index,6);

%avg wind speed for winter year1-year1+4.
avgSpeed=mean(speed);

%Divide wind direction to 16 partitions of 22.5 degrees each.
%Range 1 ranges from -11.25 to 11.25 degrees etc.
partitions=16;
range=360/partitions;
normalizedDir = arrayfun(@(x) fix((x+(range/2))/range)*range,direction);

%Find prevailing wind direction
u = unique(normalizedDir);
counts  = histc(normalizedDir,u);

%360 degrees=0 degrees
if u(end)==360
    counts(1)=counts(1)+counts(end);
    counts(end)=0;
end
    
%Prevailing wind direction
[M,I]=max(counts);
prevWindDir=u(I);

%Call windrose function
Options = {'anglenorth',0,'angleeast',90,'labels',{'N (0)','E (90)','S (180)','W (270)'},'freqlabelangle',30};
WindRose (normalizedDir,speed,Options)

%Print computer name and title.
name=getenv('COMPUTERNAME')
text(-1,-1,name)
titleString=sprintf(string('Winter months of %d to %d wind speed.'), year1,year1+4);
text(-0.4,1.17,titleString);
title2String=sprintf(string('Prevailing wind direction: %d deg.\n Average wind speed: %.2f m/s.'),prevWindDir,avgSpeed);
text(0.5,1,title2String);
  
%Note: Using 'TitleString', 'Winter Speed' prints title on top of N(0) label.
%Same problem appears in the Windrose documentation as well.
%Alternative method used.