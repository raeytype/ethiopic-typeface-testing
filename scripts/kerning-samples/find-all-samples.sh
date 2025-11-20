#!/bin/bash

export LANG=C
# perl find-pair-samples.pl am abyssinica > AbyssinicaSIL-Pair-Samples-AM.tsv
# perl find-pair-samples.pl am noto  > Noto-Pair-Samples-AM.tsv
# perl find-pair-samples.pl am nyala  > Nyala-Pair-Samples-AM.tsv

# perl find-pair-samples.pl byn abyssinica > AbyssinicaSIL-Pair-Samples-BYN.tsv
# perl find-pair-samples.pl byn noto  > Noto-Pair-Samples-BYN.tsv
# perl find-pair-samples.pl byn nyala  > Nyala-Pair-Samples-BYN.tsv

# perl find-pair-samples.pl sgw abyssinica > AbyssinicaSIL-Pair-Samples-SGW.tsv
# perl find-pair-samples.pl sgw noto  > Noto-Pair-Samples-SGW.tsv
# perl find-pair-samples.pl sgw nyala  > Nyala-Pair-Samples-SGW.tsv

# perl find-pair-samples.pl ti abyssinica > AbyssinicaSIL-Pair-Samples-TI.tsv
# perl find-pair-samples.pl ti noto  > Noto-Pair-Samples-TI.tsv
# perl find-pair-samples.pl ti nyala  > Nyala-Pair-Samples-TI.tsv

perl find-pair-samples.pl all abyssinica > AbyssinicaSIL-Pair-Samples-All.tsv
perl find-pair-samples.pl all noto  > Noto-Pair-Samples-All.tsv
perl find-pair-samples.pl all nyala  > Nyala-Pair-Samples-All.tsv
perl merge-pairs.pl > merged-pairs.tsv
perl find-pair-samples.pl all all  > Merged-Pair-Samples-All.tsv

LANG=C cat Nyala-Pair-Samples-All.tsv | sort | cut -f1-8 > sorted/Nyala-Pair-Samples-All.tsv
LANG=C cat AbyssinicaSIL-Pair-Samples-All.tsv | sort | cut -f1-8 > sorted/Abyssinica-Pair-Samples-All.tsv
LANG=C cat Noto-Pair-Samples-All.tsv | sort | cut -f1-8 > sorted/Noto-Pair-Samples-All.tsv
LANG=C cat Merged-Pair-Samples-All.tsv | sort | cut -f1-8 > sorted/Merged-Pair-Samples-All.tsv
