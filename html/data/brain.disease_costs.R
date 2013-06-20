disease = read.table("brain.disease_costs.csv",sep=",",header=TRUE,quote="\"")

# create functions to get the lower and upper bounds of the error bars
stderr <- function(x){sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))}
lowsd <- function(x){return(mean(x)-stderr(x))}
highsd <- function(x){return(mean(x)+stderr(x))}

newplot = ggplot(disease ,aes(disease,total/1e9,fill=type))+
# first layer is barplot with means
stat_summary(fun.y=mean, geom="bar", position="dodge", colour='white')+
# second layer overlays the error bars using the functions defined above
stat_summary(fun.y=mean, fun.ymin=lowsd, fun.ymax=highsd, geom="errorbar", position="dodge",color = 'black', size=.5)+
coord_flip()+
ggtitle("Cost of various diseases")+
xlab("")+
ylab("total costs ($billion)")+
#geom_text(aes(label=round(10^(log10(total)-trunc(log10(total))))),size=2)+
theme(legend.position="bottom")

print(newplot)