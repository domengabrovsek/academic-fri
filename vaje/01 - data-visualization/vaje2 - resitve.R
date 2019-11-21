#
# Resitve nalog iz vizualizacije
#

md <- read.table("movies.txt", sep=",", header=TRUE)
for (i in 18:24)
	md[,i] <- as.factor(md[,i])
	
#
# - Ali je v nasi podatkovni bazi vec filmov, ki so krajsi od 100 minut, ali je vec tistih, ki so dolgi 100 oz. vec minut?
#

tab <- table(md$length < 100)
names(tab) <- c("dolgi 100 min ali vec", "krajsi od 100 min")
tab

barplot(tab, ylab="Stevilo filmov", main="Razmerje med stevilom filmov glede na dolzino")
pie(tab, main="Delez filmov glede na dolzino")


#
# Ali je vec akcijskih komedij ali romanticnih komedij?
#
 
akcijske.komedije <- md$Action == "1" & md$Comedy == "1"
romanticne.komedije <- md$Romance == "1" & md$Comedy == "1"
tmp <- c(sum(akcijske.komedije), sum(romanticne.komedije))
names(tmp) <- c("Akcijske komedije", "Romanticne komedije")
tmp
barplot(tmp, ylab="Stevilo filmov", main="Razmerje med akcijskimi in romaticnimi komedijami")

# nalogo lahko resimo tudi s pomocjo funkcije "table"
# (lahko ugotovimo, da je 7 filmov, ki so in akcijske in romanticne komedije)
table(akcijske.komedije, romanticne.komedije)


# 
# Narisite histogram ocen za drame.
#

hist(md$rating[md$Drama == "1"], xlab="Ocena filma", ylab="Stevilo filmov", main="Histogram ocen za drame")


#  
# Ali so v povprecju drame bolje ocenjene kot ostali filmi? 
#

mean(md$rating[md$Drama == "1"])
mean(md$rating[md$Drama != "1"])

boxplot(rating ~ Drama, data=md, xlab="Vrednost atributa Drama", ylab="Ocena filma", main="Boxplot ocen za drame in ostale zvrsti")
abline(h = mean(md$rating[md$Drama == "1"]), col = "red")
abline(h = mean(md$rating[md$Drama != "1"]), col = "blue")


#
# Prikazite stevilo animirank v nasi bazi od leta 1995 naprej. 
#

sel <- md$year >= 1995

t <- table(md$Animation[sel], md$year[sel])
t
x <- colnames(t)
y <- t[2,]
plot(x,y, type="l", xlab="Leto", ylab="Stevilo filmov", main="Stevilo animirank po letih")

# nalogo lahko resimo tudi z ukazom "aggregate"
agg.com <- aggregate((Animation == "1") ~ year, md[md$year >= 1995,], sum)
plot(agg.com[,1], agg.com[,2], type="l", xlab="Leto", ylab="Stevilo filmov", main="Stevilo animirank po letih")


#
# Ali obstaja jasna locnica med kratkimi in ostalimi filmi (glede na dolzino)?
#

boxplot(length ~ Short, md, xlab="Vrednost atributa Short", ylab="Dolzina filma v min")

# na vprasanje lahko odgovorimo tudi tako...
max(md$length[md$Short == "1"]) < min(md$length[md$Short == "0"])


############################################################################################


players <- read.table("players.txt", sep=",", header = T)

#
# Izrisite razmerje stevila igralcev glede na igralne polozaje.
#

pie(table(players$position), main="Razmerje stevila igralcev po igralnih polozajih")


#
# Primerjajte stevilo dobljenih skokov ("reb") med igralci na razlicnih igralnih polozajih.
#

boxplot(reb ~ position, players, xlab="Igralni polozaj", ylab="Stevilo dobljenih skokov")
abline(h=mean(players$reb[players$position=="C"]), col="red")
abline(h=mean(players$reb[players$position=="F"]), col="blue")
abline(h=mean(players$reb[players$position=="G"]), col="green")


#
# Narisite distribucijo uspesnosti izvajanja prostih metov.
#

hist(players$ftm/players$fta, xlab="Delez zadetih prostih metov", ylab="Stevilo igralcev", main="Histogram uspesnosti izvajanja prostih metov")
boxplot(players$ftm/players$fta, ylab="Delez zadetih prostih metov", main="Uspesnost izvajanja prostih metov")


#
# Primerjajte stevilo uspesnih metov za tri tocke glede na igralne polozaje.
# (v primerjavo vkljucite samo igralce aktivne v obdobju 1990-2007)

threepts <- players$pts - (players$fgm * 2 + players$ftm)
sel <- players$firstseason >= 1990 & players$lastseason <= 2007
boxplot(threepts[sel] ~ players$position[sel], xlab="Igralni polozaj", ylab="Stevilo zadetih tock z linije za 3", main="Analiza metov za 3 tocke")


#
# Kako se iz leta v leto spreminja povprecna dolzina igralne kariere upokojenih igralcev?
#

avg.len <- aggregate((lastseason-firstseason) ~ lastseason, players, mean)
avg.len
plot(avg.len[,1], avg.len[,2], type="l", xlab="Leto", ylab="Dolzina igralne kariere v letih", main="Povprecna dolzina igralne kariere igralcev v NBA")
