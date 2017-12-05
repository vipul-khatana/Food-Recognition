% Created on Sat Oct 29 2016
% @author: vipulkhatana 

function [result] = imageClassify(filePath)

% warning ('off');
% clc;
% clear all;
% close all;

%%
%%%% TAKE THE INPUT IMAGE FROM THE FOLDER %%%

%%%%%%%%% read the input image %%%%%%%%%%%%%%%%%%%
            
% [filename pathname]=uigetfile( {'*.png'; '*.bmp';'*.tif';'*.jpg'});
% I=imread([pathname filename]);%%%% read the image  %%%%%
I=imread(filePath);
I=imresize(I,[256 256]);
% figure,imshow(I,[]);   %%%% show the image  %%%%%
% title('original image');
% [m n o]=size(I);

 %%%RGB TO GRAY CONVERSION%%%
Ig=rgb2gray(I);
% figure,imshow(Ig,[]);   %%%% show the image  %%%%%
% title('Grayscale image');

%%%%%MULTI COLOR CHANNEL SEPARATION%%%
Red=I(:,:,1);
Green=I(:,:,2);
Blue=I(:,:,3);

%%%ENHANCEMENT%%%
enh=histeq(Ig);
% figure,imshow(enh);
% title('histogram equalized Image');
[rows columns]=size(enh);

con=adapthisteq(Ig);
% figure,imshow(con);
% title('adaptive histogram equalized Image');

%%% FEATURE EXTRACTION%%%%
%%%HISTOGRAM OF GRADIENTS%%%
[feature angle magnitude] = hog_feature_vector(Ig);
% figure,imshow(feature);
% title('feature vector');
% figure,imshow(uint8(magnitude));
% title('shape detected fruit output');


%%%%LOCAL BINARY PATTERNS%%%%
%%%LOCAL BINARY PATTERN%%%
% Preallocate/instantiate array for the local binary pattern.
localBinaryPatternImage = zeros(size(enh));
for row = 2 : rows - 1   
	for col = 2 : columns - 1    
		centerPixel = enh(row, col);
		pixel7=enh(row-1, col-1) > centerPixel;  
		pixel6=enh(row-1, col) > centerPixel;   
		pixel5=enh(row-1, col+1) > centerPixel;  
		pixel4=enh(row, col+1) > centerPixel;     
		pixel3=enh(row+1, col+1) > centerPixel;    
		pixel2=enh(row+1, col) > centerPixel;      
		pixel1=enh(row+1, col-1) > centerPixel;     
		pixel0=enh(row, col-1) > centerPixel;       
		localBinaryPatternImage(row, col) = uint8(...
			pixel7 * 2^7 + pixel6 * 2^6 + ...
			pixel5 * 2^5 + pixel4 * 2^4 + ...
			pixel3 * 2^3 + pixel2 * 2^2 + ...
			pixel1 * 2 + pixel0 * 1);
	end  
end 

% figure,imshow(localBinaryPatternImage, []);
% title('Local Binary Pattern');


%%%BINARY CONVERSION%%%%
level=graythresh(I);
Ibin=im2bw(Ig,level);
Ibin=imcomplement(Ibin);
% figure,imshow(Ibin,[]);
% title('THRESHOLDED IMAGE');


%%% SHAPE BASED FEATURE EXTRACTION%%%%
   
g=regionprops(Ibin,'all');

g1=extractfield(g,'Area');
[g11 index1]=max(g1);
AR=round(g11);
            
g2=extractfield(g,'MinorAxisLength');
[g22 index2]=max(g2);
MIN=round(g22);

g3=extractfield(g,'MajorAxisLength');
[g33 index3]=max(g3);
MAJ=round(g33);


%%%CLASSIFICATION%%%%

TrainingSet=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16]; 
TestSet=[1]; 
GroupTrain=[1;1;2;2;3;3;4;4;5;5;6;6;7;7;8;8]; 
result=multisvm(TrainingSet,GroupTrain,TestSet,AR);
