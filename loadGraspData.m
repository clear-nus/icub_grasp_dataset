function [processed_data, diff_processed_data, raw_data] = loadGraspData(load_type, obsNoiseVar)

LOAD_ALL = 1;
LOAD_TACTILE_ONLY = 2;
LOAD_ENCODER_ONLY = 3;

if nargin == 0
   load_type = LOAD_ALL; 
end

if nargin == 1
    obsNoiseVar = 0;
end

if load_type == LOAD_ALL
    load_tactile = true;
    load_encoder = true;
elseif load_type == LOAD_TACTILE_ONLY
    load_tactile = true;
    load_encoder = false;
elseif load_type == LOAD_ENCODER_ONLY
    load_tactile = false;
    load_encoder = true;
end


reload_data = true; %reload raw data?

num_trials = 20; % number of smaples per object

object_labels = { ...
    'empty_vitamin_water', ...
    'med_vitamin_water', ...
    'full_vitamin_water', ...
    'empty_coke', ...
    'med_coke', ...
    'blue_bear', ...
    'monkey_toy', ...
    'book', ...
    'lotion', ...
    'none'...
    };

num_objects = length(object_labels);

p = mfilename('fullpath');
current_folder = fileparts(p);

%% load the data (RAW)
if reload_data
    for o=1:num_objects
        
        fprintf('Loading %s: [ ', object_labels{o});
        
        for i=1:num_trials
            fprintf('%d. ', i);
            
            load_filename = sprintf('%s%ciCubGraspDataset%c%s_%d.txt', ...
                current_folder, filesep, filesep, ...
                object_labels{o}, i);
            raw_data{o,i} = dlmread(load_filename);
            
        end
        fprintf('] Done! \n');
    end
end
%% Process the data -- split it up nicely and spatially condense it.
for o=1:num_objects
    fprintf('Processing %s: [ ', object_labels{o});
    for i=1:num_trials
        fprintf('%d. ', i);
        
        rdata = raw_data{o,i}(2:end,:); %ignore first line
        if obsNoiseVar > 1e-9
           rdata = rdata + normrnd(0, sqrt(obsNoiseVar),size(rdata));
        end
        
        
        processed_block = [];
        k = 1;
        for j=1:7:size(rdata,1)-1
            time_block = rdata(j:j+6,:);
            
            
            data_vec = [];
            if (load_encoder)
                data_vec = [time_block(1,1:9)];
            end
            %data_vec = 255 - data_vec;
            if load_tactile
                for finger=1:5
                    data_vec = [data_vec ...
                        mean(255 - time_block(2+finger,:)) ...
                        std(255 - time_block(2+finger,:)) ...
                        skewness(255 - time_block(2+finger,:)) ...
                        max(255 - time_block(2+finger,:)) ...
                        min(255 - time_block(2+finger,:)) ...
                        ];
                end
            end
            data_vec(not(isfinite(data_vec))) = 0.0;
            processed_block(k,:) = data_vec;
            k = k+1;    
        end
        
        processed_data{o,i} = processed_block;

    end
            fprintf('] Done! \n');
end

%% differenced data
for o=1:num_objects
    fprintf('Differenced data %s: [ ', object_labels{o});
    for i=1:num_trials
        diff_processed_data{o,i} = processed_data{o,i} - ...
            repmat(processed_data{o,i}(1,:), size(processed_data{o,i},1), 1);
        diff_processed_data{o,i} = diff_processed_data{o,i}(1:end,:);
    end
    fprintf('] Done! \n');
end



%% normalising
k=1;
max_elems = [];
min_elems = [];
for o=1:num_objects
    fprintf('Normalising %s: [ ', object_labels{o});
    for i=1:num_trials
        max_elems(k,:) = max(processed_data{o,i});
        min_elems(k,:) = min(processed_data{o,i});
        k = k+1;
    end
    fprintf('] Done! \n');
end

max_elems = max(max_elems);
min_elems = min(min_elems);
diff_elems = max_elems - min_elems;

for o=1:num_objects
    fprintf('Normalising %s: [ ', object_labels{o});
    for i=1:num_trials
        rep_min_elems = repmat(min_elems, size(processed_data{o,i},1), 1);
        rep_diff_elems = repmat(diff_elems, size(processed_data{o,i},1), 1);
        
        processed_data{o,i} = (processed_data{o,i} - rep_min_elems) ./ rep_diff_elems;
        k = k+1;
    end
    fprintf('] Done! \n');
end





%% normalising

k=1;
max_elems = [];
min_elems = [];
for o=1:num_objects
    fprintf('Normalising %s: [ ', object_labels{o});
    for i=1:num_trials
        max_elems(k,:) = max(diff_processed_data{o,i});
        min_elems(k,:) = min(diff_processed_data{o,i});
        k = k+1;
    end
    fprintf('] Done! \n');
end

max_elems = max(max_elems);
min_elems = min(min_elems);
diff_elems = max_elems - min_elems;

for o=1:num_objects
    fprintf('Normalising %s: [ ', object_labels{o});
    for i=1:num_trials
        rep_min_elems = repmat(min_elems, size(diff_processed_data{o,i},1), 1);
        rep_diff_elems = repmat(diff_elems, size(diff_processed_data{o,i},1), 1);
        
        diff_processed_data{o,i} = (diff_processed_data{o,i} - rep_min_elems) ./ rep_diff_elems;
        k = k+1;
    end
    fprintf('] Done! \n');
end

%%
fprintf('NOTE: \n\nRaw data is in raw_data{object, trial}.\n');
fprintf('Processed data is in processed_data{object, trial}.\n\n');



