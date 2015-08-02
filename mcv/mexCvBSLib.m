% function h = mexCvBSLib(image)
% mexCvBSLib - inteface to the foreground/background segmentation library.
%
% h = mexCvBSLib(image)
%       - creates a background subtraction C++ object h
%
% mexCvBSLib(h)
%       - releases the background subtraction C++ object h
%
% imMask = mexCvBSLib(image,h)
%       - performs background subtraction and updates background
%
% mexCvBSLib(image, h, parameters)
%       -this will change parameters=[fAlphaT,fTb,bShadowDetection,fTau];
%           fAlphaT - speed of update - if the time interval you want to 
%       average over is T set alpha=1/T. 
%           fTb - threshold on the squared Mahalan. dist. to decide if 
%       it is well described by the background model or not. 
%       Related to Cthr from the paper. This does not influence the update 
%       of the background. A typical value could be 4 sigma => Tb=4*4=16;
%           bShadowDetection - do shadow detection if ==1
%           fTau - shadow threshold. The shadow is detected if the pixel 
%       is darker version of the background. Tau is a threshold on how much 
%       darker the shadow can be. Tau= 0.5 means that if pixel is more 
%       than 2 times darker then it is not shadow
%
% Example usage:
%
% sName='test.avi';
% fInfo=aviinfo(sName);
% d=aviread(sName,1);
% h=mexCvBSLib(d.cdata);%Initialize
% mexCvBSLib(d.cdata,h,[0.01 5*5 1 0.5]);%Set parameters
% figure(1)
% for i=1:fInfo.NumFrames
%    d=aviread(sName,i);
%    imMask=mexCvBSLib(d.cdata,h);
%    imshow(imMask);
% end
% mexCvBSLib(h);%Release memory
%
% History
%   create  -  Z. Zivkovic (www.zoranz.net), 02-28-2007
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-20-2013
