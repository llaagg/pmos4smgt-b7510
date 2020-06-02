docker build . -t pmos:dev -f 'Dockerfile'

# mount needs that: --privileged
docker run --privileged --rm -it  pmos:dev

#docker run -ti -d --privileged -v /dev/bus/usb:/dev/bus/usb pmos:dev

# podobny do https://www.mgsm.pl/pl/katalog/samsung/gts7580/
# porownanie z ace https://www.mgsm.pl/pl/porownanie/samsung-galaxypro-vs-samsung-gts5830ace/

# Root information http://www.bernaerts-nicolas.fr/android/311-samsung-galaxy-pro-gt-b7510-root
# https://sfirmware.com/samsung-gt-b7510/

#compatible SAMSUNG GALAXY MODELS: GT-S5570, GT-S5570B, GT-S5570I, GT-S5570L, GT-S5571, GT-S5578 (Chinese-Mini), 
# GT-S5660, GT-S5660M, GT-S5660L, GT-S5660V, SHW-M290K (Korean-Gio), GT-S5670, GT-S5670B, GT-S5670L, GT-S5830, GT-S5830B, 
# GT-S5830C, GT-S5830D, GT-S5830F(La Fleur), GT-S5830G, GT-S5830i, GT-S5830L, GT-S5820, GT-S5830M, GT-S5830T, GT-S5830V, GT-S5830Z, 
# GT-S5838(Chinese-Ace), GT-S5839i, GT-S6800(Africa-Ace Advance), GT-S6802, GT-S6802B, GT-S6802L (new), GT-B5330, GT-B7510, GT-B7510B,
# GT-B7510L, GT-B7800, GT-B5510, GT-B5510B, GT-B5510L, GT-B5512, GT-B5512B, GT-S6102, GT-S6102B, GT-S5300, GT-S5300B, GT-S5300L (new), 
# GT-S5302, GT-S5302B (new), GT-S5302L (new), GT-S5360, GT-S5360B, GT-S5360L, GT-S5360T, GT-S5363, GT-S5367 (new), GT-S5368 (new), GT-S5369,
# GT-S5690, GT-S5690i, GT-S5690L, GT-S5690M, GT-S5690R, GT-I8150, GT-I8150B, GT-I5510, GT-I5510B, GT-I5510L, GT-I5510M, GT-I5510T, SCH-i110 (new), 
# SCH-i509, SCH-i559, SCH-i589(Ace Duos -Chinese/India), SGH-T499, SGH-T499Y, SGH-T499V, SGH-T499W, SGH-T589, SGH-T589R, SGH-T589W, SGH-I837, SGH-I857.

# pmbootstrap bootimg_analyze
