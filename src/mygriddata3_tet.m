function znew=mygriddata3_tet(x,y,zz,tet,z,xin,yin,zzin,tnum,pc)
    
    znew=griddata3_tet(x,y,zz,tet,z,xin,yin,zzin,tnum,pc,'linear');
  %  indx=find(isnan(znew));
  %  znew(indx)=griddata3_tet(x,y,zz,tet,z,xin(indx),yin(indx),zzin(indx),'nearest');
disp('removed for speed');