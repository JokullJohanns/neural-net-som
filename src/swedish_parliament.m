clear all;
close all;
votes;
mpdistrict;

mpsex;
num_members = length(mp_votes);
num_weights = 100;
num_features = 31;
weights = rand([num_weights, num_features]);
epochs = 200;
step_size = 0.2;
init_hood_size = 10;
hood_size = init_hood_size;
dec = hood_size*(1/epochs);
for epoch = 1:epochs %outer training loop
    for member = 1:num_members 
        hood_floor = floor(hood_size);
        p = mp_votes(member,:); 
        
        %Find the row of the weight matrix with the shortest distance to
        %this attribute vector p
        
        p_mat = repmat(p,num_weights,1); 
        difference = p_mat - weights; %Subtract two matrices to take the difference
       
        %Calculate the length of the difference vector
        %Create an array to store the distance from our difference vector
        %vector and all the weights
        
        norms = zeros(1,num_weights); 
        for i = 1:num_weights
            norms(i) = norm(difference(i,:)); %Compute the 2-norm distance
        end
        [winner, winner_index] = min(norms); %Find the smallest distance and its index
        
    
        [x,y] = meshgrid([1:10],[1:10]);
        xpox = reshape(x,1,100);
        ypox = reshape(y,1,100);

        C = vertcat(xpox, ypox)';
        the_winner = [xpox(winner_index),ypox(winner_index)]';
        Z = mandist(C,the_winner);
        
        [I, IB] = sort(Z);
        neighbors = IB(1:hood_floor);

        num_neighbors = length([neighbors]);
        p_mat = repmat(p,num_neighbors,1);
        weight_hood = weights([neighbors],:);
        weights([neighbors],:) = weight_hood + step_size*(p_mat - weight_hood); %Update the winning weight
                
    end
    hood_size = hood_size - dec; %Reduce our neighborhood size
    
end

pos = zeros(1,num_members);

for member = 1:num_members %Loop through the 32 animals one at a time, animal becomes our row index into props
        p = mp_votes(member,:); %Pick out an animal from the matrix (each row is an animal), p is an attribute vector
        
        %Find the row of the weight matrix with the shortest distance to
        %this attribute vector p
        
        p_mat = repmat(p,num_weights,1); %Make a copy of the selected animal vector to be equal to the size of the weight matrix
        difference = p_mat - weights; %Subtract two matrices to take the difference
        
        %Calculate the length of the difference vector
        %Create an array to store the distance from our difference vector
        %vector and all the weights
        
        norms = zeros(1,num_weights); 
        for i = 1:num_weights
            norms(i) = norm(difference(i,:)); %Compute the 2-norm distance
        end
        [winner, winner_index] = min(norms); %Find the smallest distance and its index
        pos(member) = winner_index;
        
       
end
[x,y] = meshgrid([1:10],[1:10]);
xpos = reshape(x, 1, 100);
ypos = reshape(y, 1, 100);
a = ones(1,100)*350;
a(pos) = 1:349;
figure(1);
mpsex;
p = [mp_sex;0];
image(p(reshape(a,10,10))+1);
figure(2);
mpparty;
p = [mp_party;0];
image(p(reshape(a,10,10))+1);
figure(3);
mpdistrict;
p = [mp_district;0];
image(p(reshape(a,10,10))+1);
