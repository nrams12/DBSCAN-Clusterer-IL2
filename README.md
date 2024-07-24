# DBSCAN-Clusterer-IL2
This program is the code used in the following paper:

Saed, B.; Ramseier, N., T.; Perera, T.; Anderson, J.; Burnett, J.; Gunasekara, H.; Burgess, A.; Jing, H.; Hu, Y., S.; Increased vesicular dynamics and nanoscale clustering of IL-2 after T cell activation Biophysical Journal 2024.
DOI: 10.1016/j.bpj.2024.03.029

%%%%%
Description:
This program inputs a dSTORM image and clusters the data using DBSCAN. The resulting clusters are then sorted, and the maximum diameter of each cluster is calculated. The code then calculates the percentage of how many clusters contain maximum diameters greater than a certain distance. 

What you will need to run the program:
1. a reconstructed dSTORM image file containing all of the x and y coordinates from the acquisition. 
2. A computer with a recommended 16 GB of RAM.


To use the program:
1. We recommend using the ImageJ plugin ThunderSTORM to reconstruct the data. Reconstruct the image how you normally would. Export the image containing all of the columns. The program inputs only the 3rd and 4th columns from the results file, which, in our case, is only the XY coordinates. The user may need to adjust the columns read by the program if their XY coordinates are not the 3rd and 4th columns. 

2. Open the MATLAB code. We recommend running this code by each section rather than all at once.
   
3. Run the first section. The program will prompt the user to select the .csv file containing the dSTORM image data.
   
4. Prior to running the next section, set the minPTS (minimum number of points) and the Epsilon (radius) in the DBSCAN section of the code. These parameters may need adjusting depending on your data. It may require this section to be rerun until adequate clusters are achieved. The program then sorts all the clusters into a struct.

5. The next section calculates the maximum diameter of each cluster by finding the distance between each XY pair and others in the same cluster and then finding the maximum. These values are then stored in the same struct.

6. The final section of the program finds the average maximum diameter of clusters in the data set. The program also calculates the percent of clusters over a certain threshold (i.e. 140 nm), which is set by the user.

7. Prgoram complete. 
