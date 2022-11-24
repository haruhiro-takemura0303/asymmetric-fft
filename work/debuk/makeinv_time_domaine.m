
function [cell_pull,cell_push] = makeinv_time_domaine (signald,signal,Fs,f)

%% Time domain Separaton

cell_push=NoiseSeparateMotion(Fs,signal,signald,1,f);
cell_pull=NoiseSeparateMotion(Fs,signal,signald,2,f);

for i=1:length(cell_push)

    if i<length(cell_push)
        cell_pull{1,i}(1,end+1) = cell_push{1,i}(1,1);
        cell_push{1,i}(1,end+1) = cell_pull{1,i+1}(1,1);
   
    else
        cell_pull{1,i}(1,end+1) = cell_push{1,i}(1,1);
    end
    
end
 
%% reshape signal

for i = 1:length(cell_push)
    
    if mod(i,2) == 1
        cell_pull{1,i}(:,end) = [];
    
    else mod(i,2) == 0
        cell_pull{1,i}(:,1)   = [];
        
    end
    
end

for i = 1:length(cell_push)-1
    
    if mod(i,2) == 1
        cell_push{1,i}(:,1) = [];
    
    else mod(i,2) == 0
        cell_push{1,i}(:,end) =   [];
        
    end
    
end

%% Inversion time-domain
for i = 1:length(cell_pull)
    
    if mod(i,2) == 0
        cell_pull{1,i} = flip(cell_pull{1,i});
    end
end
   
for i = 1:length(cell_push)
    
    if mod(i,2) == 1
        cell_push{1,i} = flip(cell_push{1,i});  
    end
end

end

