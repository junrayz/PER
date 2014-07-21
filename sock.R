load <- function(port=80) {
  so <- socketConnection(port = port)
  count = 0
  #plot(0,0,xlim=c(1,1000) , ylim=c(1,1000))
  data = c(0)
  repeat{
      count = count + 1
      temp <- readLines(so)
      if(length(temp)) {
        data = c(data , try(strtoi(temp)))
        print(data)
		#plot(data , col= 'dark blue' , type='b')
		pie(x=data)
      }
  }
  close(so)
}

load(port=8888)
