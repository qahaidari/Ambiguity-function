# Ambiguity-function
Calculating and plotting ambiguity function of a radar-repeater network

According to [1], the Ambiguity Function (AF) of an antenna array calculates the correlation between steering vectors associated to different incoming signal directions, i.e., different target angles in a given network configuration. For calculating the AF, it is assumed that a specific target angle (true angle) 𝜃p impinges on a given configuration. The correlation of this steering vector with those associated to different target angles (estimated angles) 𝜃q ∈ (−90∘, 90∘) is calculated according to [1]. The AF can be used to find the unambiguous range of the given network configuration.

To increase the network aperture and hence improve the angular resolution of a radar sensor, so-called repeater elements can be used alongside a MIMO radar sensor in a radar network. A repeater element according to [2] and [3] is a transmitter-receiver element.

In order to calculate the AF of a radar-repeater network, the virtual steering vector [4] of the network first needs to be determined. The virtual steering vector of a radar-repeater network can be calculated according to [5].

Here a radar network consisting of a MIMO radar sensor and two repeater elements is considered. The radar sensor is an exemplary MIMO radar sensor with 4 transmit and 4 receive elements. The AF of the network is calculated and the AF as well as the network array (MIMO transmit and receive elements' and the repeaters' positions) are plotted. 

References:

[1] M. Eric, A. Zejak, and M. Obradovic, “Ambiguity Characterization of Arbitrary Antenna Array: Type I Ambiguity,” IEEE, pp. 399–403, 1998.

[2] M. S. Dadash, J. Hasch, P. Chevalier, A. Cathelin, N. Cahoon, and S. P. Voinigescu, “Design of Low-Power Active Tags for Operation With 77–81-GHz FMCW Radar,” IEEE Transactions on Microwave Theory and Techniques, vol. 65, no. 12, pp. 5377–5388, Dec. 2017.

[3] B. Meinecke, M. Steiner, J. Schliechenmaier, J. Hasch, and C. Waldschmidt, “Coherent Multistatic MIMO Radar Networks Based on Repeater Tags,” IEEE Transactions on Microwave
Theory and Techniques, 2019.

[4] J. Li and P. Stoica, MIMO Radar Signal Processing. Wiley-IEEE Press, 2009.

[5] D. Werbunat, “Konzeption und Evaluation eines Sensornetzwerks basierend auf OFDMRadaren,” Master’s thesis, Universität Ulm, 2019.
