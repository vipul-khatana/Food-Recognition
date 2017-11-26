function Ikm = Km3(I,K) 

%% color + spatial (option: K (Number of Clusters))
% I = im2double(I);
[x,y] = meshgrid(1:size(I,2),1:size(I,1));            % Spatial Features
L = [y(:)/max(y(:)),x(:)/max(x(:))];
% C = reshape(I,size(I,1)*size(I,2),3);                 % Color Features 
cform = makecform('srgb2lab');
lab_he = applycform(I,cform);
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
F = [ab,L];                                            % Color & Spatial Features
[cluster_idx, cluster_center] = kmeans(F,K,'distance','sqEuclidean', ...
                                          'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:K
    color = I;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

for i = 1:K
    figure;
    imshow(segmented_images{i}), title('objects in cluster ');
end                                      
                                      
Ikm = I;
%% Kmeans Segmentation
% CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Cluster Centers
% DAL   = zeros(size(F,1),K+2);                         % Distances and Labels
% KMI   = 10;                                           % K-means Iteration
% for n = 1:KMI
%    for i = 1:size(F,1)
%       for j = 1:K  
%         DAL(i,j) = norm(F(i,:) - CENTS(j,:));      
%       end
%       [Distance CN] = min(DAL(i,1:K));                % 1:K are Distance from Cluster Centers 1:K 
%       DAL(i,K+1) = CN;                                % K+1 is Cluster Label
%       DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
%    end
%    for i = 1:K
%       A = (DAL(:,K+1) == i);                          % Cluster K Points
%       CENTS(i,:) = mean(F(A,:));                      % New Cluster Centers
%       if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
%          NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
%          for Ind = 1:size(NC,1)
%          CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
%          end
%       end
%    end
% end

% X = zeros(size(F));
% for i = 1:K
% idx = find(DAL(:,K+1) == i);
% X(idx,:) = repmat(CENTS(i,:),size(idx,1),1); 
% end
% Ikm = reshape(X(:,1:3),size(I,1),size(I,2),3);

end