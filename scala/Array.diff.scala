  def arrayDiff(a: Seq[Int], b: Seq[Int]): Seq[Int] = {
    // Your code here
    for{n<-a
        if(!b.contains(n))
    } yield n
  }
