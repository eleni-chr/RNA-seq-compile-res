function IlluminaQualityData
fileList=dir('*.txt');
PerBaseSequenceQuality=[];
for i=1:length(fileList)
    fname=fileList(i).name;
    sampleID=fname(1:end-4);
    opts=detectImportOptions(fname);
    data=readtable(fname,'FileType','delimitedtext','Range','B14:B73','ReadVariableNames',false);
    data.Properties.VariableNames={sampleID};
    PerBaseSequenceQuality=[PerBaseSequenceQuality,data];
end
vars=PerBaseSequenceQuality.Properties.VariableNames;
PerBaseSequenceQuality.meanPerBaseSequenceQuality=mean(PerBaseSequenceQuality{:,vars},2);
W=length(fileList)-1;
W=repmat(W,[W+1,1]);
PerBaseSequenceQuality.stdPerBaseSequenceQuality=std(PerBaseSequenceQuality{:,vars},W,2);
writetable(PerBaseSequenceQuality,'PerBaseSequenceQuality.xlsx','WriteMode','replacefile');

PerSequenceGCcontent=[];
for i=1:length(fileList)
    fname=fileList(i).name;
    sampleID=fname(1:end-4);
    opts=detectImportOptions(fname);
    data=readcell(fname,opts);
    
    for j=1:length(data)
        content=data(j,1);
        content=cell2mat(content);
        if ischar(content)
            if strcmp(content,'#GC Content')
                idxLine=j+77;
            end
        end
    end
    startRange=strcat('B',mat2str(idxLine));
    endRange=strcat('B',mat2str(idxLine+100));
    cellRange=strcat(startRange,':',endRange);
    data=readtable(fname,'FileType','delimitedtext','Range',cellRange,'ReadVariableNames',false);
    data.Properties.VariableNames={sampleID};
    PerSequenceGCcontent=[PerSequenceGCcontent,data];
end
vars=PerSequenceGCcontent.Properties.VariableNames;
PerSequenceGCcontent.meanPerSequenceGCcontent=mean(PerSequenceGCcontent{:,vars},2);
W=length(fileList)-1;
W=repmat(W,[W+1,1]);
PerSequenceGCcontent.stdPerSequenceGCcontent=std(PerSequenceGCcontent{:,vars},W,2);
writetable(PerSequenceGCcontent,'PerSequenceGCcontent.xlsx','WriteMode','replacefile');

SequenceLengthDistribution=[];
for i=1:length(fileList)
    fname=fileList(i).name;
    sampleID=fname(1:end-4);
    opts=detectImportOptions(fname);
    data=readcell(fname,opts);
    
    for j=1:length(data)
        content=data(j,1);
        content=cell2mat(content);
        if ischar(content)
            if strcmp(content,'#Length')
                idxLine=j+77;
            end
        end
    end
    startRange=strcat('B',mat2str(idxLine));
    endRange=strcat('B',mat2str(idxLine+43));
    cellRange=strcat(startRange,':',endRange);
    data=readtable(fname,'FileType','delimitedtext','Range',cellRange,'ReadVariableNames',false);
    data.Properties.VariableNames={sampleID};
    SequenceLengthDistribution=[SequenceLengthDistribution,data];
end
vars=SequenceLengthDistribution.Properties.VariableNames;
SequenceLengthDistribution.meanSequenceLengthDistribution=mean(SequenceLengthDistribution{:,vars},2);
W=length(fileList)-1;
W=repmat(W,[W+1,1]);
SequenceLengthDistribution.stdSequenceLengthDistribution=std(SequenceLengthDistribution{:,vars},W,2);
writetable(SequenceLengthDistribution,'SequenceLengthDistribution.xlsx','WriteMode','replacefile');

PerSequenceQualityScores=[];
for i=1:length(fileList)
    fname=fileList(i).name;
    sampleID=fname(1:end-4);
    opts=detectImportOptions(fname);
    data=readcell(fname,opts);
    
    for j=1:length(data)
        content=data(j,1);
        content=cell2mat(content);
        if ischar(content)
            if strcmp(content,'#Quality')
                idxLine=j+77;
            end
            if strcmp(content,'>>Per base sequence content')
                idxLineEnd=j+74;
            end
        end
    end
    startRange=strcat('B',mat2str(idxLine));
    endRange=strcat('B',mat2str(idxLineEnd));
    cellRange=strcat(startRange,':',endRange);
    data=readtable(fname,'FileType','delimitedtext','Range',cellRange,'ReadVariableNames',false);
    data.Properties.VariableNames={sampleID};
    if height(data)<35
        missingQualities=array2table(zeros(35-height(data),1));
        missingQualities.Properties.VariableNames={sampleID};
        data=[missingQualities;data];
    end
    PerSequenceQualityScores=[PerSequenceQualityScores,data];
end
vars=PerSequenceQualityScores.Properties.VariableNames;
PerSequenceQualityScores.meanPerSequenceQualityScores=mean(PerSequenceQualityScores{:,vars},2);
W=length(fileList)-1;
W=repmat(W,[W+1,1]);
PerSequenceQualityScores.stdPerSequenceQualityScores=std(PerSequenceQualityScores{:,vars},W,2);
writetable(PerSequenceQualityScores,'PerSequenceQualityScores.xlsx','WriteMode','replacefile');
end