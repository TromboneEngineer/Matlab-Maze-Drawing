function mazefunction
clear all; close all; figure; hold all;
set(gca,'XTickLabel',''); set(gca,'YTickLabel',''); set(gca,'Color','w');
global xmax ymax width paths ytop ybot pausetime pathcolor pathdistance pairs j
xmax=1000;%10000 % the length of the visible screen
ymax=1000;%10000 % the height of the visible screen
width=18; % the distance between paths
paths=20;%201 % the number of paths that split from the beginning
pausetime=.05; % 0, 0.001;
%widthrange
[paths]=pathnum;
[pairs]=matchingindex;
%pathcolor='w';
pathcolor='wbgykrmc';
colormap(jet(600));
while length(pathcolor)<=2*paths
    pathcolor=[pathcolor,pathcolor];
end
ypoint=zeros(1,2*paths);
[xpoint(1,1:paths),ypoint(1,1:paths)]=opening(0,1);
[xpoint(1,1+paths:2*paths),ypoint(1,1+paths:2*paths)]=opening(xmax,-1);
iterations=13; % 3, 30;

lineangleA(1,:)=(pi/2)*ones(1,paths);
lineangleB(1,:)=-lineangleA;
lineangle=[lineangleA,lineangleB];
for i=1:iterations
    for j=1:2*paths
        [xpoint(i+1,j),ypoint(i+1,j),lineangle(i+1,j)]=drawmaze(xpoint(i,j),ypoint(i,j),lineangle(i,j));
    end
end
opening(0,1);
opening(xmax,-1);

    function [xout,yout,lineangleout]=drawmaze(xinitial,yinitial,lineanglein)
        [xline,yline,x1,y1,x2,y2,xout,yout,lineangleout]=calculate(xinitial,yinitial,lineanglein);
        %             while max(xout)>xmax-4*width | min(xout)<4*width | max(yout)>ymax-.5*width | min(yout)<.5*width
        %                 [xline,yline,x1,y1,x2,y2,xout,yout,lineangleout]=calculate(xinitial,yinitial,lineanglein);
        %             end
        for z=1:10000
            if max(xout)>xmax-4*width | min(xout)<4*width | max(yout)>ymax-3*width | min(yout)<3*width
                [xline,yline,x1,y1,x2,y2,xout,yout,lineangleout]=calculate(xinitial,yinitial,lineanglein);
            end
        end
        for z=1:10000
            if max(xout)>xmax-2*width | min(xout)<2*width | max(yout)>ymax-1.5*width | min(yout)<1.5*width
                [xline,yline,x1,y1,x2,y2,xout,yout,lineangleout]=calculate(xinitial,yinitial,lineanglein);
            end
        end
%            while max(xout)>xmax-4*width | min(xout)<4*width | max(yout)>ymax-.5*width | min(yout)<.5*width
        while max(xout)>xmax | min(xout)<0 | max(yout)>ymax-2*width | min(yout)<2*width
            [xline,yline,x1,y1,x2,y2,xout,yout,lineangleout]=retrycalculate(xinitial,yinitial,lineanglein);
        end
        
        draw(xinitial,yinitial,lineanglein,xline,yline,x1,y1,x2,y2);
       % axis equal
        axis([0 xmax 0 ymax])
    end
    function [xline,yline,x1,y1,x2,y2,xout,yout,lineangleout]=calculate(xinitial,yinitial,lineanglein)
        distance=10*width*rand(1);
        xline=xinitial+distance*cos(lineanglein-pi/2);
        yline=yinitial+distance*sin(lineanglein-pi/2);
        
        ran=rand(1,2);
        if ran(1)<.5
            direction=-1;
        else
            direction=1;
        end
        if ran(2)<.75
%            lineangleout=lineanglein+direction*pi/4;
            lineangleout=lineanglein+direction*(pi/8+rand(1)*pi/4);
        else
%            lineangleout=lineanglein+direction*3*pi/4;
            lineangleout=lineanglein+direction*(pi/2+rand(1)*pi/2);
        end
        arcangle=linspace(lineanglein,lineangleout);
        r=3*rand(1)*width+width;
        x=xline-direction*r*(-cos(lineanglein)+cos(arcangle));
        y=yline-direction*r*(-sin(lineanglein)+sin(arcangle));
        x1=xline-direction*.5*width*cos(lineanglein)-direction*(r+width/2)*(-cos(lineanglein)+cos(arcangle));
        y1=yline-direction*.5*width*sin(lineanglein)-direction*(r+width/2)*(-sin(lineanglein)+sin(arcangle));
        x2=xline+direction*.5*width*cos(lineanglein)-direction*(r-width/2)*(-cos(lineanglein)+cos(arcangle));
        y2=yline+direction*.5*width*sin(lineanglein)-direction*(r-width/2)*(-sin(lineanglein)+sin(arcangle));
        
        xout=x(end);
        yout=y(end);
        
    end
    function [xline,yline,x1,y1,x2,y2,xout,yout,lineangleout]=retrycalculate(xinitial,yinitial,lineanglein)
        distance=.5*width*rand(1);
        xline=xinitial+distance*cos(lineanglein-pi/2);
        yline=yinitial+distance*sin(lineanglein-pi/2);
        
        ran=rand(1,2);
        if ran(1)<.5
            direction=-1;
        else
            direction=1;
        end
        if ran(2)<.75
            lineangleout=lineanglein+direction*rand(1)*pi/4;
        else
            lineangleout=lineanglein+direction*3*rand(1)*pi/4;
        end
        arcangle=linspace(lineanglein,lineangleout);
        r=3*rand(1)*width+width;
        x=xline-direction*r*(-cos(lineanglein)+cos(arcangle));
        y=yline-direction*r*(-sin(lineanglein)+sin(arcangle));
        x1=xline-direction*.5*width*cos(lineanglein)-direction*(r+width/2)*(-cos(lineanglein)+cos(arcangle));
        y1=yline-direction*.5*width*sin(lineanglein)-direction*(r+width/2)*(-sin(lineanglein)+sin(arcangle));
        x2=xline+direction*.5*width*cos(lineanglein)-direction*(r-width/2)*(-cos(lineanglein)+cos(arcangle));
        y2=yline+direction*.5*width*sin(lineanglein)-direction*(r-width/2)*(-sin(lineanglein)+sin(arcangle));
        
        xout=x(end);
        yout=y(end);
        
    end
    function draw(xinitial,yinitial,lineanglein,xline,yline,x1,y1,x2,y2)
        X=[[xinitial-.5*width*cos(lineanglein),xline-.5*width*cos(lineanglein)],fliplr([xinitial+.5*width*cos(lineanglein),xline+.5*width*cos(lineanglein)])];
        Y=[[yinitial-.5*width*sin(lineanglein),yline-.5*width*sin(lineanglein)],fliplr([yinitial+.5*width*sin(lineanglein),yline+.5*width*sin(lineanglein)])];
        pathfill(X,Y,1)
        plot([xinitial-.5*width*cos(lineanglein),xline-.5*width*cos(lineanglein)],[yinitial-.5*width*sin(lineanglein),yline-.5*width*sin(lineanglein)],'k')
        plot([xinitial+.5*width*cos(lineanglein),xline+.5*width*cos(lineanglein)],[yinitial+.5*width*sin(lineanglein),yline+.5*width*sin(lineanglein)],'k')
        if pausetime>0
            pause(pausetime);
        end
        
        X=[x1,fliplr(x2)];
        Y=[y1,fliplr(y2)];
        pathfill(X,Y,1)
        plot(x1,y1,'k')
        plot(x2,y2,'k')
        if pausetime>0
            pause(pausetime);
        end
    end
    function [pathsout]=pathnum
        ytop=ymax-2*width;
        ybot=0+2*width;
        maxpath=(ytop-ybot+2*width)/(3*width);
        if maxpath-round(maxpath)<0
            maxpath=round(maxpath)-1;
        else
            maxpath=round(maxpath);
        end
        if paths > maxpath
            paths=maxpath;
        end
        if mod(paths,2)==0
            paths=paths-1;
        end
        pathsout=paths;
    end
    function [xout,yout]=opening(xref,xdir)
%        ytop=ymax-width/2; ybot=width/2;
        straight=ytop-ybot-(3*width*(paths-1)+width);
        xintro1=[xref,xref+xdir*width];
        yintro1a=[ymax/2+width/2,ymax/2+width/2];
        yintro1b=[ymax/2-width/2,ymax/2-width/2];
        X=[[xintro1],[fliplr(xintro1)]];
        Y=[[yintro1a],[fliplr(yintro1b)]];
        pathfill(X,Y,2)
        plot(xintro1,yintro1a,'k')
        plot(xintro1,yintro1b,'k')
        xvertical=xref+xdir*2*width;
        yvertical=[ybot+2*width,ymax/2-1.5*width,ymax/2+1.5*width,ytop-2*width];
        plot([xvertical,xvertical],yvertical(1:2),'k')
        plot([xvertical,xvertical],yvertical(3:4),'k')
        xvertical=xref+xdir*3*width;
        for j=1:paths-1
            yvertical(j)=ybot+2*width+(j-1)*(3*width+straight/(paths-1));
            yvertical2(j)=ybot+2*width+straight/(paths-1)+(j-1)*(3*width+straight/(paths-1));
            plot([xvertical,xvertical],[yvertical(j),yvertical2(j)],'k');
        end
        
        a=-pi/2; b=0; r=width; h=width; k=ymax/2+1.5*width;
        xbridgein(1,:)=xref+xdir*(r*cos(linspace(a,b))+h);
        ybridgein(1,:)=r*sin(linspace(a,b))+k;
        a=0; b=pi/2; r=width; h=width; k=ymax/2-1.5*width;
        xbridgein(2,:)=xref+xdir*(r*cos(linspace(a,b))+h);
        ybridgein(2,:)=r*sin(linspace(a,b))+k;
        X=[xbridgein(1,:),xbridgein(2,:)];
        Y=[ybridgein(1,:),ybridgein(2,:)];
        pathfill(X,Y,2)
        plot(xbridgein(1,:),ybridgein(1,:),'k')
        plot(xbridgein(2,:),ybridgein(2,:),'k')
        
        a=pi/2; b=pi; r=2*width; h=4*width; k=ytop-2*width;
        xoutertop=xref+xdir*(r*cos(linspace(a,b))+h);
        youtertop=r*sin(linspace(a,b))+k;
        a=pi; b=3*pi/2; k=ybot+2*width;
        xouterbot=xref+xdir*(r*cos(linspace(a,b))+h);
        youterbot=r*sin(linspace(a,b))+k;
        [xindex1,xindex1]=min(abs(xouterbot-(xref+xdir*3*width)));
        xselectbot=xouterbot(1:xindex1);
        yselectbot=youterbot(1:xindex1);
        [xindex2,xindex2]=min(abs(xoutertop-(xref+xdir*3*width)));
        xselecttop=xoutertop(xindex2:end);
        yselecttop=youtertop(xindex2:end);
        X=[xselectbot,xselecttop];
        Y=[yselectbot,yselecttop];
        pathfill(X,Y,2)
        plot(xouterbot,youterbot,'k')
        plot(xoutertop,youtertop,'k')
        
        h=4*width; r=width;
        for j=1:paths-1
            a=pi; b=3*pi/2; k=ybot+2*width+(3*width+straight/(paths-1))*(j-1);
            xinner(j,:)=xref+xdir*(r*cos(linspace(a,b))+h);
            yinner(j,:)=r*sin(linspace(a,b))+k;
            a=pi/2; b=pi; k=k+straight/(paths-1);
            xinner(paths-1+j,:)=xref+xdir*(r*cos(linspace(a,b))+h);
            yinner(paths-1+j,:)=r*sin(linspace(a,b))+k;
        end
        for j=1:paths-2
            X=[xinner(paths-1+j,:),xinner(j+1,:)];
            Y=[yinner(paths-1+j,:),yinner(j+1,:)];
            pathfill(X,Y,2)
        end
        X=[xinner(1,:),fliplr(xouterbot(xindex1:end))];
        Y=[yinner(1,:),fliplr(youterbot(xindex1:end))];
        pathfill(X,Y,2)
        X=[xinner(end,:),fliplr(xoutertop(1:xindex2))];
        Y=[yinner(end,:),fliplr(youtertop(1:xindex2))];
        pathfill(X,Y,2)
        for j=1:2*paths-2
            plot(xinner(j,:),yinner(j,:),'k')
        end
        for j=1:paths
            xout(1,j)=xref+xdir*4*width;
            yout(1,j)=ybot+.5*width+(j-1)*(3*width+straight/(paths-1));
        end
    end
    function pathfill(X,Y,mode)
        %mode 1=center
        %mode 2=opening
%         if mode==1
%         h=fill(X,Y,pathcolor(j));
%         else
%         h=fill(X,Y,pathcolor(1));
%         end
        h=fill(X,Y,X);
        set(h,'EdgeColor','None');
    end
    function [pairs]=matchingindex
        list=1:paths;
        leftorder=list(randperm(length(list)));
        rightorder=list(randperm(length(list)))+paths;
        connectpair(:,1)=[leftorder(end),rightorder(end)];
        for i=1:(paths-1)/2
            leftpair(:,i)=[leftorder(2*i-1),leftorder(2*i)];
            rightpair(:,i)=[rightorder(2*i-1),rightorder(2*i)];
        end
        pairs=[leftpair,rightpair,connectpair];
    end
end