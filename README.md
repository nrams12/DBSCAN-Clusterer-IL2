# DBSCAN-Clusterer-IL2
This code inputs a dSTORM image and clusters the data using DBSCAN. The resulting clusters are then sorted, and the maximum diameter of each cluster is calculated. The code then calculates the percentage of how many clusters contain maximum diameters greater than a certain distance. 

What you will need to run the code:
1. a reconstructed dSTORM image file containing all of the x and y coordinates from the acquisition. 
2. A computer with a recommended 16 GB of RAM.


To use the code:
1. We recommend using the ImageJ plugin ThunderSTORM to reconstruct the data. Reconstruct the image how you normally would. Export the image containing all of the columns.

2. Open the MATLAB code. We recommend running this code by each section rather than all at once.
   
3. Run the first section. The program will prompt the user to select the .csv file containing the dSTORM image data.
   
4. Prior to running the next section, set the minPTS (minimum number of points) and the Epsilon (radius) in the DBSCAN section of the code. These parameters may need adjusting depending on your data. It may require this section to be rerun until adequate clusters are achieved. The program then sorts all the clusters into a struct.

5. The next section calculates the maximum diameter of each cluster by finding the distance between each XY pair and others in the same cluster and then finding the maximum. These values are then stored in the same struct.

6. fwe
