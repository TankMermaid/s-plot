#!/bin/bash

#set -x

usage()
{
cat <<EOF
${txtcyn}

***CREATED BY Chen Tong (chentong_biology@163.com)***

Usage:

$0 options${txtrst}

${bldblu}Function${txtrst}:

This script is used to draw bar plot using ggplot2.

fileformat for -f (suitable for data extracted from one sample, the
number of columns is unlimited. Column 'Set' is not necessary)
------------------------------------------------------------
Pos	h3k27ac	ctcf	enhancer	h3k4me3	polII
-5000	8.71298	10.69130	11.7359	10.02510	8.26866
-4000	8.43246	10.76680	11.8442	9.76927	7.78358
-3000	8.25497	10.54410	12.2470	9.40346	6.96859
-2000	7.16265	10.86350	12.6889	8.35070	4.84365
-1000	3.55341	8.45751	12.8372	4.84680	1.26110
0	3.55030	8.50316	13.4152	5.17401	1.50022
1000	7.07502	10.91430	12.3588	8.13909	4.88096
2000	8.24328	10.70220	12.3888	9.47255	7.67968
3000	8.43869	10.41010	11.9760	9.80665	7.94148
4000	8.48877	10.57570	11.6562	9.71986	8.17849
-------------------------------------------------------------
fileformat when -m is true 
#Three columns needed, the column given to -a should not be variable
#or value. Be carefull to name you x-axis variable.
#The name "value" and "variable" shoud not be altered.
#Actually this format is the melted result of last format.
--------------------------------------------------------------
Pos variable    value	Set 
-5000	h3k27ac	8.71298
-4000	h3k27ac	8.43246
-3000	h3k27ac	8.25497
-2000	h3k27ac	7.16265
-1000	h3k27ac	3.55341
0	h3k27ac	3.55030
1000	h3k27ac	7.07502
2000	h3k27ac	8.24328
3000	h3k27ac	8.43869
4000	h3k27ac	8.48877
-5000	ctcf	10.69130
-4000	ctcf	10.76680
-3000	ctcf	10.54410
-2000	ctcf	10.86350
-1000	ctcf	8.45751
0	ctcf	8.50316
1000	ctcf	10.91430
2000	ctcf	10.70220
3000	ctcf	10.41010
4000	ctcf	10.57570
-------------------------------------------------------------

${txtbld}OPTIONS${txtrst}:
	-f	Data file (with header line, the first column 
 		will be treated as rownames, tab seperated)${bldred}[NECESSARY]${txtrst}
	-m	When true, it will skip melt preprocesses. But the format must be
		the same as listed before.
		${bldred}[Default FALSE, accept TRUE]${txtrst}
	-a	Name for x-axis variable
		[${txtred}Necessary, no default value when -m is used.  
		For the second examples, 'Pos' should be given here. 
		For the first example,  default the first column will be used,
		program will assign an value 'xvariable' to represent it.
	   	]${txtrst}]
	-A	The attribute of x-axis variable.
		[${txtred}Default TRUE, means X-axis label is text.
		FALSE means X-axis label is number.${txtrst}]
	-G	Name for legend column.
		[${txtred}Default 'variable'. Should only be changed when -m is TRUE.${txtrst}]
	-I	Name for value column.
		[${txtred}Default 'value'. Should only be changed when -m is TRUE.${txtrst}]
	-T	Tag for this plot. Normally used when multiple plots generated from one file.
		[${txtred}Optional.${txtrst}]
	-g	Error-bar column.
		Specify the column containing error bars.
		Melted format should be supplied (-m TRUE) and -d should be set to dodge.
	-d	The ways to place multiple bars for one group if there are. 
		Multiple bars in same place will be stacked together by
		default.
		Giving "fill" to get stacked percent barplot.	
		Giving "dodge" to arrange multiple bars side-by-side. 
		[${txtred}Default stack, accept dodge, fill. ${txtrst}]
	-D	The ways to show the height of bars.
		The height of bars represent the numerical values in each group
		by default (normally in value column of melted data). 
		One can also give 'count' to let the program count the number of 
		items in each group (Normally the 'variable' column is used to group 
		'xvariable' colum after melt).
		Or one can give 'weight' which will sum values of eacg group.
		[${txtred}Default identity, accept count when categorial data
		are given. ${txtrst}]
	-l	Levels for legend variable
		[${txtred}Default column order, accept a string like
		"'ctcf','h3k27ac','enhancer'"  
		***When -m is used, this default will be ignored too.********* 
	   	${txtrst}]
	-P	Legend position[${txtred}Default right. Accept
		top,bottom,left,none, or c(0.08,0.8).${txtrst}]
	-L	Levels for x-axis variable, suitable when x-axis is not used
		as a number. 
		[${txtred}Default the order of first column, accept a string like
		"'g','a','j','x','s','c','o','u'"  
	   	This will only be considered when -A is TRUE.
		***When -m is used, this default will be ignored too.********* 
		${txtrst}]
	-X	Display xtics. ${bldred}[Default TRUE]${txtrst}
	-Y	Display ytics. ${bldred}[Default TRUE]${txtrst}
	-R	Rotation angle for x-axis value(anti clockwise)
		${bldred}[Default 0]${txtrst}
	-F	Rotate the plot. 
		Usefull for plots with many values or very long labels at X-axis.
		${bldred}[Default FALSE]${txtrst}
	-t	Title of picture[${txtred}Default empty title${txtrst}]
	-x	xlab of picture[${txtred}Default empty xlab${txtrst}]
	-y	ylab of picture[${txtred}Default empty ylab${txtrst}]
	-B	Wrap plots by given column. This is used to put multiple plot
		in one picture. Used when -m is TRUE, normally a string <set>
		should be suitable for this parameter.
	-b	The levels of wrapping to set the order of each group.
		${txtred}Normally the unique value of the column given to B in
		a format like <"'a','b','c','d'">.${txtrst}
	-o	The number of rows one want when -B is used.Default NULL.
		${txtred}[one of -o and -O is enough]${txtrst}
	-O	The number of columns one want when -B is used.Default NULL.
		${txtred}[one of -o and -O is enough]${txtrst}
	-k	Paramter for scales for facet.
		[${txtred}Optional, only used when -B is given. Default each 
		inner graph use same scale [x,y range]. 'free','free_x','free_y' 
		is accepted. ${txtrst}]
	-c	Manually set colors for each bar.[${txtred}Default FALSE,
		meaning using ggplot2 default.${txtrst}]
	-C	Color for each bar.[${txtred}
		When -c is TRUE, one have two options
		1. Supplying a function to generate colors, 
		like "rainbow(11)" or "rainbow(11, alpha=0.6)", 
		    rainbow is an R color palletes, 
		    11 is the number of colors you want to get, 
			0.6 is the alpha value.
		The R palletes include heat.colors, terrain.colors,
		topo.colors, cm.colors.
		2. Supplying a list of colors in given format, 
		ususlly the number of colors should be equal to the number of
		bars like "'red','pink','blue','cyan','green','yellow'" or
		"rgb(255/255,0/255,0/255),rgb(255/255,0/255,255/255),
		 rgb(0/255,0/255,255/255),rgb(0/255,255/255,255/255),
		 rgb(0/255,255/255,0/255),rgb(255/255,255/255,0/255)"
		${txtrst}]
	-s	Scale y axis
		[${txtred}Default null. Accept TRUE. 
		If the supplied number after -S is not 0, this
		parameter will be automatically TRUE${txtrst}]
	-v	If scale is TRUE, give the following
		scale_y_log10()[default], coord_trans(y="log10"), or other legal
		command for ggplot2)${txtrst}]
	-S	A number to add if scale is used.
		[${txtred}Default 0. If a non-zero number is given, -s is
		TRUE.${txtrst}]	
	-p	Other legal R codes for gggplot2 will be given here.
		[${txtres}Begin with '+' ${txtrst}]
	-w	The width of output picture.[${txtred}Default 20${txtrst}]
	-u	The height of output picture.[${txtred}Default 12${txtrst}] 
	-E	The type of output figures.[${txtred}Default pdf, accept
		eps/ps, tex (pictex), png, jpeg, tiff, bmp, svg and wmf)${txtrst}]
	-r	The resolution of output picture.[${txtred}Default 500${txtrst}]
	-z	Is there a header[${bldred}Default TRUE${txtrst}]
	-e	Execute or not[${bldred}Default TRUE${txtrst}]
	-i	Install depended packages[${bldred}Default FALSE${txtrst}]
EOF
}

file=
title=''
melted='FALSE'
xlab=' '
ylab=' '
xvariable='xvariable'
level="''"
x_level="''"
x_type='TRUE'
scaleY='FALSE'
y_add=0
scaleY_x='scale_y_log10()'
header='TRUE'
execute='TRUE'
facet='NoMeAnInGTh_I_n_G_s'
stat='identity'
position='stack'
facet_level='NA'
nrow='NULL'
ncol='NULL'
ist='FALSE'
uwid=20
vhig=12
error_bar='ctCTct'
res=500
ext='pdf'
par=''
legend_pos='right'
xtics='TRUE'
xtics_angle=0
ytics='TRUE'
color='FALSE'
color_v=''
vline=0
scales='fixed'
rotate_plot='FALSE'
variable='variable'
value='value'
tag=''

while getopts "hf:m:a:A:t:x:F:l:G:I:T:g:k:d:D:P:L:y:V:o:O:B:b:c:C:X:Y:R:w:u:r:s:S:p:z:v:e:E:i:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			file=$OPTARG
			;;
		m)
			melted=$OPTARG
			;;
		a)
			xvariable=$OPTARG
			;;
		A)
			x_type=$OPTARG
			;;
		V)
			vline=$OPTARG
			;;
		t)
			title=$OPTARG
			;;
		d)
			position=$OPTARG
			;;
		D)
			stat=$OPTARG
			;;
		x)
			xlab=$OPTARG
			;;
		l)
			level=$OPTARG
			;;
		G)
			variable=$OPTARG
			;;
		I)
			value=$OPTARG
			;;
		T)
			tag=$OPTARG
			;;
		k)
			scales=$OPTARG
			;;
		g)
			error_bar=$OPTARG
			;;
		P)
			legend_pos=$OPTARG
			;;
		c)
			color=$OPTARG
			;;
		C)
			color_v=$OPTARG
			;;
		X)
			xtics=$OPTARG
			;;
		R)
			xtics_angle=$OPTARG
			;;
		F)
			rotate_plot=$OPTARG
			;;
		Y)
			ytics=$OPTARG
			;;
		o)
			nrow=$OPTARG
			;;
		O)
			ncol=$OPTARG
			;;
		B)
			facet=$OPTARG
			;;
		b)
			facet_level=$OPTARG
			;;
		L)
			x_level=$OPTARG
			;;
		p)
			par=$OPTARG
			;;
		y)
			ylab=$OPTARG
			;;
		w)
			uwid=$OPTARG
			;;
		u)
			vhig=$OPTARG
			;;
		r)
			res=$OPTARG
			;;
		E)
			ext=$OPTARG
			;;
		s)
			scaleY=$OPTARG
			;;
		S)
			y_add=$OPTARG
			;;
		v)
			scaleY_x=$OPTARG
			;;
		z)
			header=$OPTARG
			;;
		e)
			execute=$OPTARG
			;;
		i)
			ist=$OPTARG
			;;
		?)
			usage
			exit 1
			;;
	esac
done

if [ -z $file ]; then
	usage
	exit 1
fi

if test ${y_add} -ne 0; then
	scaleY="TRUE"
fi

mid='.'${position}${tag}'Bars'

cat <<END >${file}${mid}.r

if ($ist){
	install.packages("ggplot2", repo="http://cran.us.r-project.org")
	install.packages("reshape2", repo="http://cran.us.r-project.org")
	install.packages("grid", repo="http://cran.us.r-project.org")
}
library(ggplot2)
library(reshape2)
library(grid)

if(! $melted){
	data <- read.table(file="${file}", sep="\t", header=$header,
	row.names=1, quote="", check.names=F)
	data_rownames <- rownames(data)
	data_colnames <- colnames(data)
	data\$${xvariable} <- data_rownames
	data_m <- melt(data, id.vars=c("${xvariable}"))
} else {
	data_m <- read.table(file="$file", sep="\t",
	header=$header, quote="")
}

if (${y_add} != 0){
	data_m\$${value} <- data_m\$${value} + ${y_add}
}

level_i <- c(${level})
if (length(level_i) >1){
	data_m\$${variable} <- factor(data_m\$${variable}, levels=level_i)
} else {
	if (! $melted) {
	data_m\$${variable} <- factor(data_m\$${variable}, levels=data_colnames,
	ordered=T)
	}
}

if (${x_type}){
	x_level <- c(${x_level})
	if (length(x_level)>1){
		data_m\$${xvariable} <- factor(data_m\$${xvariable},levels=x_level)
	}else{
		if (! $melted) {
			data_m\$${xvariable} <- factor(data_m\$${xvariable}, 
			levels=data_rownames,ordered=TRUE)
		}
	}
}


if ("${facet_level}" != "NA") {
	facet_level <- c(${facet_level})
	data_m\$${facet} <- factor(data_m\$${facet},
	levels=facet_level, ordered=T)
}

if ("${stat}" == "count"){
	#p <- ggplot(data_m, aes($xvariable, fill=factor(${variable})))
	p <- ggplot(data_m, aes($xvariable))
} else {
	#p <- ggplot(data_m, aes($xvariable, ${value}, fill=factor(${variable})))
	p <- ggplot(data_m, aes($xvariable, ${value}))
}

p <- p + xlab("${xlab}") + ylab("${ylab}") + theme_bw() +
	theme(legend.title=element_blank(),
   	panel.grid.major = element_blank(), panel.grid.minor = element_blank())

p <- p + theme(axis.ticks.x = element_blank(), legend.key=element_blank()) 

#legend.background = element_rect(colour='white'))

#legend.background = element_rect(fill = "white"), legend.box=NULL, 
#legend.margin=unit(0,"cm"))

#p <- p + geom_bar(stat="${stat}", position="${position}")
p <- p + geom_bar(stat="${stat}", position="${position}", aes(fill=${variable}))

if ("${error_bar}" != "ctCTct") {
	p <- p + geom_errorbar(aes(ymin=${value}-${error_bar}, ymax=${value}+${error_bar}, colour="black", width=0.1, position=position_dodge(.9)))
}

if ("${position}" == "fill"){
	p <- p + scale_y_continuous(labels = scales::percent)
}

if ("${facet}" != "NoMeAnInGTh_I_n_G_s"){
	p <- p + facet_wrap( ~ ${facet}, nrow=${nrow}, ncol=${ncol},
	scale="${scales}")
}

#if (${smooth}){
#	if ("${line_size}" != ""){
#		p <- p + stat_smooth(method="${smooth_method}", se=FALSE,
#		size=${line_size})
#	}else{
#		p <- p + stat_smooth(method="${smooth_method}", se=FALSE,
#		size=${line_size})
#	}	
#}else{
#	if ("${line_size}" != ""){
#		p <- p + geom_line(size=${line_size}) 
#	}else{
#		p <- p + geom_line() 
#	}
#}

if("$scaleY"){
	p <- p + $scaleY_x
}

if(${color}){
	p <- p + scale_fill_manual(values=c(${color_v}))
}

if ("$xtics" == "FALSE"){
	p <- p + theme(axis.text.x=element_blank())
}else{
	if (${xtics_angle} != 0){
		if (${xtics_angle} == 90){
			p <- p + theme(axis.text.x=
			  element_text(angle=${xtics_angle},hjust=1, vjust=0.5))
		}else if (${xtics_angle} == 45){
			p <- p + theme(axis.text.x=
			  element_text(angle=${xtics_angle},hjust=1, vjust=1))
		} else {
			p <- p + theme(axis.text.x=
			  element_text(angle=${xtics_angle},hjust=0.5, vjust=0.5))
		}
	}
}
if ("$ytics" == "FALSE"){
	p <- p + theme(axis.text.y=element_blank())
}


top='top'
botttom='bottom'
left='left'
right='right'
none='none'
legend_pos_par <- ${legend_pos}

p <- p + theme(legend.position=legend_pos_par)

#custom_vline_coord <- ${vline}
#if(length(custom_vline_coord) > 1){
#	p <- p + geom_vline(xintercept=custom_vline_coord, 
#	linetype="dotted" )
#}


if(${rotate_plot}){
	p <- p + coord_flip()	
}

p <- p${par}

ggsave(p, filename="${file}${mid}.${ext}", dpi=$res, width=$uwid,
height=$vhig, units=c("cm"))
#postscript(file="${file}${mid}.eps", onefile=FALSE, horizontal=FALSE, 
#paper="special", width=10, height = 12, pointsize=10)
#dev.off()
END

if [ "$execute" == "TRUE" ]; then
	Rscript ${file}${mid}.r
#if [ "$?" == "0" ]; then /bin/rm -f ${file}${mid}.r; fi
fi

