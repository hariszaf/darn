# Set base image
Bootstrap: docker
From: hariszaf/darn:latest

%labels
	Maintainer Haris Zafeiropoulos

# Set Singularity environment
%post
	export WORKDIR="/home"
	echo "export WORKDIR=$WORKDIR" >> $SINGULARITY_ENVIRONMENT
	mkdir -p $WORKDIR

