function compileCounts

mouseWT={'FCD8-1','FCD9-9','FCD9-10'};
mouseFLX={'FCD10-6','FCD14-1','FCD7-2'};
mouseLOA={'FCD10-4','FCD5-28','FCD7-6'};
mouseFLXLOA={'FCD14-2','FCD8-27','FCD10-3'};

files=dir('*.csv');
n=length(files);
Image_name=cell(n,1);
Count=cell(n,1);
Genotype=char(zeros(n,24));
Geno_code=zeros(n,1);
for i=1:n
    fname=files(i).name;
    data=readtable(fname);
    Image_name{i}=fname;
    Count{i}=data.Var2;

    %Add genotypes
    ID=extractBefore(fname,'_');
    mouseID{i,1}=ID;
    if ismember(ID,mouseWT)
        Genotype(i,:)='DYNC1H1(+/+),CHAT(+/CRE)';
        Geno_code(i)=1;
    elseif ismember(ID,mouseFLX)
        Genotype(i,:)='DYNC1H1(+/F),CHAT(+/CRE)';
        Geno_code(i)=2;
    elseif ismember(ID,mouseLOA)
        Genotype(i,:)='DYNC1H1(+/L),CHAT(+/CRE)';
        Geno_code(i)=3;
    elseif ismember(ID,mouseFLXLOA)
        Genotype(i,:)='DYNC1H1(F/L),CHAT(+/CRE)';
        Geno_code(i)=4;
    end
end
T=table(Image_name);
T.Count=Count;
T.Genotype=Genotype;
T.Geno_code=Geno_code;
T.mouseID=mouseID;

%Separate data by genotype
WT=T(T.Geno_code==1,:);
FLX=T(T.Geno_code==2,:);
LOA=T(T.Geno_code==3,:);
FLXLOA=T(T.Geno_code==4,:);
T=removevars(T,{'Geno_code'});

%Summarise data
T_WT=[];
T_FLX=[];
T_LOA=[];
T_FLXLOA=[];

for i=1:length(mouseWT)
    mouseID=mouseWT(i);
    genotype={'DYNC1H1(+/+),CHAT(+/CRE)'};
    lookup=WT(strcmp(WT.mouseID,mouseID),:);
    total_count=sum(cell2mat(lookup.Count)); %total cell count per animal
    T_WT=[T_WT;table(mouseID,genotype,total_count)];
end

for i=1:length(mouseFLX)
    mouseID=mouseFLX(i);
    genotype={'DYNC1H1(+/F),CHAT(+/CRE)'};
    lookup=FLX(strcmp(FLX.mouseID,mouseID),:);
    total_count=sum(cell2mat(lookup.Count));
    T_FLX=[T_FLX;table(mouseID,genotype,total_count)];
end

for i=1:length(mouseLOA)
    mouseID=mouseLOA(i);
    genotype={'DYNC1H1(+/L),CHAT(+/CRE)'};
    lookup=LOA(strcmp(LOA.mouseID,mouseID),:);
    total_count=sum(cell2mat(lookup.Count));
    T_LOA=[T_LOA;table(mouseID,genotype,total_count)];
end

for i=1:length(mouseFLXLOA)
    mouseID=mouseFLXLOA(i);
    genotype={'DYNC1H1(F/L),CHAT(+/CRE)'};
    lookup=FLXLOA(strcmp(FLXLOA.mouseID,mouseID),:);
    total_count=sum(cell2mat(lookup.Count));
    T_FLXLOA=[T_FLXLOA;table(mouseID,genotype,total_count)];
end
T2=[T_WT;T_FLX;T_LOA;T_FLXLOA];

%Save file
writetable(T,'cellCounts.xlsx','Sheet','All data','WriteMode','replacefile');
writetable(WT,'cellCounts.xlsx','Sheet','WT','WriteMode','overwritesheet');
writetable(FLX,'cellCounts.xlsx','Sheet','FLX','WriteMode','overwritesheet');
writetable(LOA,'cellCounts.xlsx','Sheet','LOA','WriteMode','overwritesheet');
writetable(FLXLOA,'cellCounts.xlsx','Sheet','FLX-LOA','WriteMode','overwritesheet');
writetable(T2,'cellCounts.xlsx','Sheet','Summary','WriteMode','overwritesheet');
end