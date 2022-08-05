library(ggplot2)

g1 <- ggplot(mpg, aes(displ, hwy, colour = class)) + geom_point()

ggsave('plot2.png', g1)