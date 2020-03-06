
library(imlib)
library(ggplot2)

RES <- 100

dat <- readRDS("data/prepped_data.rds") 
dat <- dat[dat$year > 1946,]
m <- readRDS("models/t3_m7.rds")

predictors <- c("lfree_fair_elections","lhorizontal_constraint_narrow")

variables <- lapply(predictors,function(x) { seq(0,1,length.out = RES) })
names(variables) <- predictors

ts <- makeTestSet(dat,variables,mean)


for(v in predictors){
   ts[[paste0(v,"_sq")]] <- ts[[v]] ^ 2
}

ts[[paste(predictors[1],predictors[2],sep=":")]] <- ts[[predictors[1]]] * ts[[predictors[2]]]
ts[[paste(predictors[2],predictors[1],sep=":")]] <- ts[[predictors[1]]] * ts[[predictors[1]]]

ts$timesince_sq <- ts$timesince ^ 2
ts$timesince_cb <- ts$timesince ^ 3

ts <- ts[names(ts) %in% names(coef(m))]

ts <- cbind(ts,sim(ts,m))

print(head(ts))

plt <- ggplot(ts,aes(x=lfree_fair_elections,y=sim_mean,
   color=lhorizontal_constraint_narrow,group=lhorizontal_constraint_narrow)) +
   geom_line() +
   theme(legend.position="none")

ggsave("/tmp/view.png",plt,width=4,height=4,device="png")

write.csv(ts,"data/simulated.csv")
