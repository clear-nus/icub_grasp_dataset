iCub Grasp Dataset
Copyright 2012 Harold Soh
Email: hss09@imperial.ac.uk

== Introduction ==

This dataset contains grasping data for nine-everyday objects 
(and a base-line "no object") collected using the iCub humanoid platform. 
The objects are: plastic bottle (full), plastic bottle (half-full), 
plastic bottle (empty), soda can (half-full), soda can (empty), 
teddy bear, monkey soft-toy, a bottle of lotion and a hardcover book. 

** There is an additional "full-coke" object but we had problems during
data collection and this data should not be considered reliable.

For details about how this dataset was collected, please refer to the 
paper:

Harold Soh, Yanyu Su and Yiannis Demiris, "Online Spatio-Temporal Gaussian 
Process Experts with Application to Tactile Classification", 
IEEE/RSJ International Conference on Intelligent Robots and Systems, 
2012.

Harold Soh and Yiannis Demiris, "Iteratively Learning Objects by Touch: Online Discriminative and Generative Models for Tactile-­based Recognition", IEEE Transactions on Haptics, 2014.

Please contact me for a draft if you don't have access to the paper. 
One should be available on my website soon: http://www.haroldsoh.com

== MATLAB Script ==
There is a MATLAB script to load the data: loadGraspData.m

This will produce two main structures: 

raw_data{object_id, trial}: The raw data is organised as described in the 
next section.

processed_data{object_id, trial}: Each row is a vector of features, i.e.,
9 encoder features and 10 tactile features (the mean and std for each 
of the 5 finger).

== Dataset Details and File Format ==

All files are contained within the iCubGraspDataset folder. 
Each of the 10 object classes was grasped 20 times (a trial).
 Each trial is stored in a separate file labelled in order from 1 to 20. 
For example, blue_bear_8.txt contains the tactile and encoder values for 
the iCub fingers for the blue teddy bear object on the 8th grasping trial. 

The file itself is formatted. The first line (-10000) can be safely 
ignored. Each time slice is represented by 7 lines. For example:

20.7273 81.0666 15.3808 0.543514 40.3876 66.6667 36.2748 55.5405 2.00816 
14.0 15.0 11.0 14.0 11.0
242.0 242.0 241.0 243.0 243.0 243.0 242.0 243.0 243.0 242.0 243.0 243.0
243.0 243.0 244.0 243.0 242.0 242.0 242.0 240.0 243.0 243.0 242.0 242.0
244.0 244.0 246.0 251.0 252.0 244.0 248.0 248.0 248.0 245.0 247.0 244.0
241.0 243.0 244.0 244.0 244.0 244.0 243.0 243.0 244.0 244.0 244.0 243.0
244.0 244.0 247.0 248.0 248.0 247.0 248.0 247.0 246.0 247.0 248.0 245.0

Line Number and Explanation:
1: the encoder values for each of the joints in the iCub hand (joints 7-15)
2: max(255 - tactile reading) for each of the five fingers 
3: the tactile reading for each of the twelve sensors for the thumb
4: the tactile reading for each of the twelve sensors for the index finger
5: the tactile reading for each of the twelve sensors for the middle finger
6: the tactile reading for each of the twelve sensors for the ring finger
7: the tactile reading for each of the twelve sensors for the little finger

== Copyright and Usage ==

You can use and distribute this dataset freely as long as you keep the 
copyright information intact. If you use this dataset for research, 
please cite my paper:

Harold Soh, Yanyu Su and Yiannis Demiris, "Online Spatio-Temporal 
Gaussian Process Experts with Application to Tactile Classification", 
IEEE/RSJ International Conference on Intelligent Robots and Systems, 2012

Please send me an email if you find it useful; I would like to know how 
people are using this data. Good luck with your work/play and have fun! 




 