object SumOfDigits {

  def digitalRoot(n: Int): Int = {
      n match {
        case x if(x.toString.length == 1) =>  x
        case x if(x.toString.length != 1) => {
          val summ = (for{i<-n.toString.map(_.asDigit)
          } yield i).sum
          digitalRoot(summ)
        }
      }
  }
  
}
