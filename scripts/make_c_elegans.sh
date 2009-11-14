#!/bin/sh

#
# Downloads sequence and builds Bowtie indexes for for C. elegans
# versions WS190 and WS200 from wormbase.
#

GENOMES_MIRROR=ftp://ftp.gramene.org/pub/wormbase/genomes/c_elegans/sequences/dna

BOWTIE_BUILD_EXE=./bowtie-build
if [ ! -x "$BOWTIE_BUILD_EXE" ] ; then
	if ! which bowtie-build ; then
		echo "Could not find bowtie-build in current directory or in PATH"
		exit 1
	else
		BOWTIE_BUILD_EXE=`which bowtie-build`
	fi
fi

get() {
	file=$1
	if ! wget --version >/dev/null 2>/dev/null ; then
		if ! curl --version >/dev/null 2>/dev/null ; then
			echo "Please install wget or curl somewhere in your PATH"
			exit 1
		fi
		curl -o `basename $1` $1
		return $?
	else
		wget $1
		return $?
	fi
}

F=elegans.WS190.dna.fa
if [ ! -f $F ] ; then
	FGZ=elegans.WS190.dna.fa.gz
	wget ${GENOMES_MIRROR}/$FGZ
	gunzip $FGZ
fi

F=elegans.WS200.dna.fa
if [ ! -f $F ] ; then
	FGZ=elegans.WS200.dna.fa.gz
	wget ${GENOMES_MIRROR}/$FGZ
	gunzip $FGZ
fi

CMD="${BOWTIE_BUILD_EXE} elegans.WS190.dna.fa c_elegans_ws190"
echo "Running $CMD"
if $CMD ; then
	echo "c_elegans_ws190 index built"
else
	echo "Index building failed; see error message"
fi

CMD="${BOWTIE_BUILD_EXE} elegans.WS200.dna.fa c_elegans_ws200"
echo "Running $CMD"
if $CMD ; then
	echo "c_elegans_ws200 index built"
else
	echo "Index building failed; see error message"
fi
