# frequency-allocation

The steps for the algorithm to create a frequency allocation:
  1. Create neighbor list for every AP in the topology
  2. Give points to the different APs in the neighbor list. More points to the APs that are closest to other APs (or links)
  3. Collect all the points given from all neighbor lists
  4. Assign frequencies to the APs in descending order with respect to points recieved
